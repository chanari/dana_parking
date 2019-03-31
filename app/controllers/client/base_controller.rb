class Client::BaseController < ApplicationController
  layout 'client'

  before_action :authenticate_user!
  before_action :profile?

  private

  def profile?
    if current_user.is_client? && current_user.profile.nil?
      redirect_to create_profile_client_profile_path(current_user)
    end
  end
end
