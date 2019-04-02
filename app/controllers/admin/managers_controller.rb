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
      AdminMailer.with(mail: @user.email, password: password).send_manager_info.deliver_later
      flash[:success] = 'New Manager Created.'
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
      flash[:success] = 'Updated.'
      redirect_to edit_profile_admin_managers_path
    else
      flash[:errors] = @profile.errors.full_messages
      redirect_to edit_profile_admin_managers_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone, :address, :user_id)
  end
  def set_profile
    @profile = Profile.find_by user_id: @admin.id
    @profile = @admin.build_profile unless @profile.present?
  end
end
