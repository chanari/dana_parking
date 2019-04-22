class Admin::BookingController < Admin::BaseController
  def index
    @parks = Parking.all.pluck(:address, :id)
  end
end
