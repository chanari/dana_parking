class Client::BookingController < Client::BaseController

  def index
    @parkings = Parking.where(active: true).pluck(:id, :address)
    @vehicles = current_user.vehicles.pluck(:number_plate)
  end

  def create
    @parking_slot = ParkingSlot.find_by id: params[:slot_id]
    @client_book = ParkingSlot.find_by client: current_user.id
    respond_to do |format|
      unless @parking_slot.present? || params[:number_plate].nil? || params[:number_plate].size < 10 || @client_book.present?
        format.json { render json: false, status: 404 }
      end
      if @parking_slot.reserve(params[:number_plate], current_user.id)
        format.json { render json: false, status: :ok }
      else
        format.json { render json: @parking_slot.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_floors
    @floors = Floor.get_floors(params[:park_id], params[:block_size])
    respond_to do |format|
      if params[:park_id].nil? || params[:block_size].nil? || @floors.nil?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: @floors.as_json(except: [:created_at, :updated_at], include: { blocks: { only: [:id, :name], include: { parking_slots: { except: [:created_at, :updated_at, :block_id] }} }}), status: :ok }
      end
    end
  end

  def get_slot_detail
    @slot = ParkingSlot.find_by id: params[:slot_id]
    @slot_expired = @slot.date_in + 30.minutes
    respond_to do |format|
      unless @slot.present?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: { slot_expired: @slot_expired.strftime("%d-%m-%Y %H:%M:%S") } }
      end
    end
  end

  def cancel_slot
    @slot = ParkingSlot.find_by id: params[:slot_id]
    respond_to do |format|
      if @slot.present? && @slot.status == '1' && @slot.reserve_expired
        format.json { render json: @slot, status: :ok}
      else
        format.json { render json: false, status: 404 }
      end
    end
  end
end
