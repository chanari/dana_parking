class Admin::BookingController < Admin::BaseController
  def index
    if params[:park] && params[:park].present?
      hash = { true => 'Tháng', false => 'Ngày' }
      @histoty = ParkingSlotReservation.get_histories(params[:park], params[:type], params[:from_day], params[:to_day])
    else
      @histoty = nil
    end
    respond_to do |format|
      format.html {}
      format.xlsx do
        send_data(ParkingSlotReservation.get_histories_xlsx(params[:park], params[:type], params[:from_day], params[:to_day]), :disposition => 'attachment', :type => 'application/excel', :filename => "ThongKe.xlsx")
      end
    end
  end
end
