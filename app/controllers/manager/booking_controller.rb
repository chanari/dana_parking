class Manager::BookingController < Manager::BaseController
  before_action :set_park, only: %i(index load_park)

  def index
    if @parking.present?
      @parking_address = @parking.address
    else
      @parking_address = 'Bạn chưa quản lý bãi nào'
    end
  end

  def slot_book
    @slot = ParkingSlot.find_by id: params[:slot_id]
    @parking_slot_reservation = @slot.parking_slot_reservations.build(number_plate: params[:number_plate], timein: DateTime.now, user_id: current_user.id)
    respond_to do |format|
      unless @slot.present? || @slot.status != '2'
        format.json { render json: false, status: 404 }
      end
      if params[:type] == 'day'
        if @slot.update(status: '2') && @parking_slot_reservation.update(price: @slot.price_by_hours )
          format.json { render json: false, status: :ok }
        else
          format.json { render json: false, status: 404 }
        end
      else
        subtotal = @slot.price_by_months.to_i * params[:quantity].to_i
        timeout = DateTime.now + params[:quantity].to_i.month
        if @slot.update(status: '2') && @parking_slot_reservation.update(is_paid: true, price: @slot.price_by_months, subtotal: subtotal, timeout: timeout)
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
        format.json { render json: @floors.as_json(include: { blocks: { except: %i(created_at updated_at), include: { parking_slots: { except: %i(block_id created_at updated_at) } } }}), status: :ok }
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
        if @parking_slot_reservation.update(is_paid: true, timeout: DateTime.now, subtotal: subtotal)
          format.json { render json: @parking_slot_reservation, status: :ok }
        else
          format.json { render json: false, status: 404 }
        end
      end
    end
  end

  private

  def set_park
    @parking = Parking.find_by id: current_user.parking_id
  end
end
