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

  private

  def parking_params
    params.require(:parking).permit(:address, floors_attributes: [:id, :name, :size, :price_by_hours, :price_by_months, blocks_attributes: [:id, :name, :slots]])
  end
end
