class Client::ProfileController < Client::BaseController
  before_action :set_user, only: %i(show update_password upload_avatar create_vehicle destroy_vehicle)
  before_action :set_profile, except: %i(upload_avatar)
  skip_before_action :profile?, only: %i(update create_profile)

  def show
    @vehicle = Vehicle.new
    @vehicles = @user.vehicles
  end

  def update
    if @profile.update_attributes profile_params
      flash[:success] = 'Đã cập nhật.'
      redirect_to client_profile_path
    else
      flash[:errors] = @profile.errors.full_messages
      redirect_to update_profile_client_profile_path(current_user)
    end
  end

  def update_password
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:success] = 'Đã cập nhật.'
      redirect_to client_profile_path(@user)
    else
      flash[:error] = 'Không thành công!'
      redirect_to client_profile_path(@user)
    end
  end

  def create_profile
    @profile = Profile.new
    # render layout: 'client'
  end

  def upload_avatar
    if params[:user] && params[:user][:avatar].present?
      @user.avatar.attach(params[:user][:avatar])
      flash[:success] = 'Đã cập nhật.'
      redirect_to client_profile_path(@user)
    elsif params[:user].nil? || params[:user][:avatar].nil?
      @user.avatar.purge_later
      flash[:success] = 'Đã cập nhật.'
      redirect_to client_profile_path(@user)
    else
      flash[:error] = 'Không thành công !'
      redirect_to client_profile_path(@user)
    end
  end

  def create_vehicle
    @vehicle = @user.vehicles.build vehical_params
    if @vehicle.save
      flash[:success] = 'Đã cập nhật.'
    else
      flash[:error] = 'Không thành công !'
    end
    redirect_to client_profile_path(@user)
  end

  def destroy_vehicle
    @vehicle = Vehicle.find_by id: params[:id]
    if @vehicle.destroy
      flash[:success] = 'Thành công.'
    else
      flash[:error] = 'Không thành công !'
    end
    redirect_to client_profile_path(@user)
  end

  def history
    @histories = ParkingSlotReservation.where(is_paid: true, number_plate: current_user.vehicles.select(:number_plate))
  end

  private

  def set_profile
    @profile = Profile.find_by user_id: params[:id]
    @profile = Profile.new unless @profile.present?
  end

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:profile).permit(:id, :first_name, :last_name, :phone, :address, :user_id)
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def vehical_params
    params.require(:vehicle).permit(:number_plate, :vehicle_name, :vehicle_type)
  end
end
