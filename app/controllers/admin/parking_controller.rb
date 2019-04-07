class Admin::ParkingController < Admin::BaseController


  def index
  end

  def new
    @parking = Parking.new
    @floor = @parking.floors.build
    @block = @floor.blocks.build
  end

  def create
    @parking = Parking.new parking_params
  end

  private

  def parking_params
    params.require(:parking).permit(:address, floors_attributes: [:id, :size, :price_by_hours, :price_by_months, blocks_attributes: [:id, :name, :slots]])
  end
end
