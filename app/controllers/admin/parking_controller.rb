class Admin::ParkingController < Admin::BaseController

  def index
    @parkings = Parking.all.pluck(:id, :address)
  end

  def new
    @parking = Parking.new
    @floor = @parking.floors.build(name: '1')
    @block = @floor.blocks.build
  end

  def create
    @parking = Parking.new parking_params
    if @parking.save
      flash[:success] = 'Saved.'
      redirect_to new_admin_parking_path
    else
      flash[:error] = 'Failed !'
      redirect_to new_admin_parking_path
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

  private

  def parking_params
    params.require(:parking).permit(:address, floors_attributes: [:id, :name, :size, :price_by_hours, :price_by_months, blocks_attributes: [:id, :name, :slots]])
  end
end
