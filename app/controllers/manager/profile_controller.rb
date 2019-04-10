class Manager::ProfileController < Manager::BaseController

  before_action :set_user_profile, only: %i(edit update)

  def edit
  end

  def update
    if params[:commit] == 'Cap nhat'
      if @user.update_with_password(user_params)
        bypass_sign_in(@user)
        flash[:success] = 'Da Cap Nhat.'
        redirect_to edit_manager_profile_path(@user)
      else
        flash[:error] = 'That Bai !'
        redirect_to edit_manager_profile_path(@user)
      end
    elsif params[:commit] == 'Luu'
      if @profile.update_attributes profile_params
        flash[:success] = 'Da Luu.'
        redirect_to edit_manager_profile_path(@user)
      else
        flash[:errors] = @profile.errors.full_messages
        redirect_to edit_manager_profile_path(@user)
      end
    end
  end

  private

  def set_user_profile
    @profile = Profile.find_by user_id: current_user.id
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone, :address)
  end
end
