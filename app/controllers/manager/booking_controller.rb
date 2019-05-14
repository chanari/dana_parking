class Manager::BookingController < Manager::BaseController
  before_action :set_park, only: %i(index load_park)

  def index
    if @parking.present?
      @parking_address = @parking.address
    else
      @parking_address = 'Bạn chưa quản lý bãi nào hoặc bãi đã đóng cửa.'
    end
  end

  def slot_book
    @slot = ParkingSlot.find_by id: params[:slot_id]
    @parking_slot_reservation = @slot.parking_slot_reservations.build(number_plate: params[:number_plate], timein: DateTime.now, user_id: current_user.id)
    respond_to do |format|
      unless @slot.present? || @slot.status != '2' || params[:number_plate].size < 10
        format.json { render json: false, status: 404 }
      end
      if params[:type] == 'day'
        if @slot.update(status: '2', number_plate: params[:number_plate], date_in: DateTime.now) && @parking_slot_reservation.update(price: @slot.price_by_hours )
          format.json { render json: false, status: :ok }
        else
          format.json { render json: false, status: 404 }
        end
      else
        subtotal = @slot.price_by_months.to_i * params[:quantity].to_i
        timeout = DateTime.now + params[:quantity].to_i.month
        if @slot.update(status: '2', number_plate: params[:number_plate], date_in: DateTime.now) && @parking_slot_reservation.update(is_paid: true, price: @slot.price_by_months, subtotal: subtotal, timeout: timeout, is_monthly: true, park_id: @slot.block.floor.parking_id)
          SlotExpiredJob.set(wait: params[:quantity].to_i.minutes).perform_later(@slot.id, true)
          format.json { render json: false, status: :ok }
        else
          format.json { render json: false, status: 404 }
        end
      end
    end
  end

  def get_slot_detail
    @parking_slot_reservation = ParkingSlotReservation.where(parking_slot_id: params[:slot_id]).order("id DESC").first
    respond_to do |format|
      unless @parking_slot_reservation.present?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: @parking_slot_reservation.as_json(except: %i(created_at updated_at user_id), methods: [:total_time]), status: :ok }
      end
    end
  end

  def load_park
    respond_to do |format|
      if params[:size] && ['1','2','3'].include?(params[:size]) && @parking.present?
        @floors = Floor.get_floors(@parking.id, params[:size])
        format.json { render json: @floors.as_json(except: [:created_at, :updated_at], include: { blocks: { except: %i(created_at updated_at), include: { parking_slots: { except: %i(block_id created_at updated_at) } } }}), status: :ok }
      else
        format.json { render json: false, status: 404 }
      end
    end
  end

  def pay
    @parking_slot_reservation = ParkingSlotReservation.find_by id: params[:reserve_id]
    respond_to do |format|
      unless @parking_slot_reservation.present?
        format.json { render json: false, status: 404 }
      else
        @slot = @parking_slot_reservation.parking_slot
        subtotal = @slot.price_by_hours.to_i * @parking_slot_reservation.total_time
        if @slot.reserve_expired && @parking_slot_reservation.update(is_paid: true, timeout: DateTime.now, subtotal: subtotal, park_id: @slot.block.floor.parking_id)
          format.json { render json: @parking_slot_reservation, status: :ok }
        else
          format.json { render json: false, status: 404 }
        end
      end
    end
  end

  def get_reserve_detail
    @slot = ParkingSlot.find_by id: params[:slot_id]
    respond_to do |format|
      unless @slot.present?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: @slot.as_json(only: [:id, :date_in, :number_plate]), status: :ok }
      end
    end
  end

  def cancel_reserve
    @slot = ParkingSlot.find_by id: params[:slot_id]
    respond_to do |format|
      if @slot.present? && @slot.reserve_expired
        format.json { render json: false, status: :ok }
      else
        format.json { render json: false, status: 404 }
      end
    end
  end

  def accept_reserve
    @slot = ParkingSlot.find_by id: params[:slot_id]
    @parking_slot_reservation = @slot.parking_slot_reservations.build(number_plate: params[:bks], timein: DateTime.now, user_id: current_user.id, price: @slot.price_by_hours)
    respond_to do |format|
      if @parking_slot_reservation.save && @slot.update(status: '2')
        format.json { render json: false, status: :ok }
      else
        format.json { render json: false, status: 404 }
      end
    end
  end

  def find_bks
    @slot = ParkingSlot.find_by number_plate: params[:bks]
    @floor = Floor.joins(blocks: :parking_slots).where(blocks: { parking_slots: { id: @slot.id } }).take()
    case @floor.size
    when '1'
      size = '4 - 7 chỗ'
    when '2'
      size = '12 - 16 chỗ'
    when '3'
      size = 'Trên 16 chỗ'
    end
    slotname = @slot.block.name + ' - ' + @slot.name
    respond_to do |format|
      if @slot.present?
        format.json { render json: { park: @floor.parking.address, size: size, slotname: slotname }, status: :ok }
      else
        format.json { render json: false, status: 404 }
      end
    end
  end

  private

  def set_park
    @parking = Parking.find_by id: current_user.parking_id, active: true
  end
end
