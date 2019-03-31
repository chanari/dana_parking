class Client::ProfileController < Client::BaseController

  before_action :set_profile
  skip_before_action :profile?, only: %i(create_profile, update)

  def show
  end

  def update
    if @profile.update_attributes profile_params
      flash[:success] = 'Updated.'
      redirect_to client_profile_path
    else
      flash[:errors] = @profile.errors.full_messages
      redirect_to update_profile_client_profile_path(current_user)
    end
  end

  def create_profile
    @profile = Profile.new
    render layout: 'application'
  end

  private

  def set_profile
    @profile = Profile.find_by user_id: params[:id]
    @profile = Profile.new unless @profile.present?
  end

  def profile_params
    params.require(:profile).permit(:id, :first_name, :last_name, :phone, :address, :user_id)
  end
end
