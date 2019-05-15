class Admin::ManagersController < Admin::BaseController
  before_action :set_profile, only: %i(edit_profile update_profile)

  def index
    @managers = User.includes(:profile).where(role: '1')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    @user.password = password
    @user.confirmed_at = DateTime.now
    @user.skip_confirmation!
    @user.role = '1'

    @profile = @user.build_profile profile_params
    if @user.save && @profile.save
      SendMailJob.set(wait: 3.seconds).perform_later(@user.email, password)
      flash[:success] = 'Thành công.'
      redirect_to new_admin_manager_path
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_admin_manager_path
    end
  end

  def edit_profile
  end

  def update_profile
    if @profile.update_attributes profile_params
      flash[:success] = 'Đã cập nhật!'
      redirect_to edit_profile_admin_managers_path
    else
      flash[:errors] = @profile.errors.full_messages
      redirect_to edit_profile_admin_managers_path
    end
  end

  def update_parking
    @manager = User.find_by(id: params[:user_id], role: '1')
    respond_to do |format|
      if params[:parking_id].nil? || params[:user_id].nil? || @manager.nil?
        format.json { render json: false, status: 404 }
      else
        if @manager.update_attribute(:parking_id, params[:parking_id])
          format.json { render json: @manager, status: :ok }
        else
          format.json { render json: @manager.errors, status: 500 }
        end
      end
    end
  end

  def remove_parking
    @manager = User.find_by(id: params[:user_id], role: '1')
    respond_to do |format|
      if params[:user_id].nil? || @manager.nil?
        format.json { render json: false, status: 404 }
      else
        if @manager.update_attribute(:parking_id, nil)
          format.json { render json: @manager, status: :ok }
        else
          format.json { render json: @manager.errors, status: 500 }
        end
      end
    end
  end

  def get_manager
    @manager = User.find_by(parking_id: params[:parking_id], role: '1')
    @profile = Profile.find_by(user_id: @manager.id) if @manager.present?
    respond_to do |format|
      if params[:parking_id].nil? || @manager.nil? || @profile.nil?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: @profile.as_json(only: [:first_name, :last_name]), status: :ok }
      end
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password(user_password_params)
      bypass_sign_in(@user)
      flash[:success] = 'Đã cập nhật'
      redirect_to edit_password_admin_managers_path
    else
      flash[:error] = 'Thất bại !'
      redirect_to edit_password_admin_managers_path
    end
  end

  def clients
    @clients = User.includes(:profile).where(role: '0')
  end

  def get_profile
    @total = ParkingSlotReservation.client_paid(Vehicle.where(user_id: params[:user_id]).pluck(:number_plate))
    @month = ParkingSlotReservation.client_paid_month(Vehicle.where(user_id: params[:user_id]).pluck(:number_plate))
    respond_to do |format|
      unless @total.present?
        format.json { render json: false, status: 404 }
      else
        format.json { render json: { total: @total, month: @month}, status: :ok }
      end
    end
  end

  def helps
    @helps = Helper.all.order(is_read: :asc, created_at: :desc).paginate(page: params[:page], per_page: 5)
  end

  def help_isread
    @help = Helper.find_by id: params[:id]
    if @help.update(is_read: true)
      flash[:success] = 'Đã cập nhật.'
    else
      flash[:error] = 'Thất bại !'
    end
    redirect_to helps_admin_managers_path
  end

  def manager_reset_password
    @manager = User.find_by(id: params[:m_id], role: '1')
    return false unless @manager.present?

    respond_to do |format|
      if @manager.update(user_password_params)
        SendMailJob.set(wait: 3.seconds).perform_later(@manager.email, user_password_params[:password])
        format.json { render json: false, status: :ok }
      else
        format.json { render json: false, status: 404 }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone, :address, :user_id)
  end
  def set_profile
    @profile = Profile.find_by user_id: @admin.id
    @profile = @admin.build_profile unless @profile.present?
  end
end
