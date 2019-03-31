class Client::ProfileController < Client::BaseController
  before_action :set_profile, only: %i(show)

  def show

  end

  private

  def set_profile
    @profile = Profile.find_by user_id: params[:id]
  end
end
