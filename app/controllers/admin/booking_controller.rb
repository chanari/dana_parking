class Admin::BookingController < Admin::BaseController
  def index
    if params[:park] && params[:park].present?
      hash = { true => 'Tháng', false => 'Ngày' }
      @histoty = ParkingSlotReservation.get_histories(params[:park], params[:type], params[:from_day], params[:to_day])
    else
      @histoty = nil
    end
  end
end
