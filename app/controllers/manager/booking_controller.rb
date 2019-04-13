class Manager::BookingController < Manager::BaseController
  before_action :set_park, only: %i(index load_park)

  def index
    if @parking.present?
      @parking_address = @parking.address
    else
      @parking_address = 'Bạn chưa quản lý bãi nào'
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

  private

  def set_park
    @parking = Parking.find_by id: current_user.parking_id
  end
end
