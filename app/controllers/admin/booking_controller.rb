class Admin::BookingController < Admin::BaseController
  def index
    if params[:park] && params[:park].present?
      if params[:from_day].empty? || params[:to_day].empty?
        flash[:error] = 'Bạn chưa chọn ngày !'
        redirect_to admin_booking_index_path
      end
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
