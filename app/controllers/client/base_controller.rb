class Client::BaseController < ApplicationController
  layout 'client'

  before_action :authenticate_user!
  before_action :is_client?
  before_action :profile?

  private

  def is_client?
    unless current_user.role == '0'
      flash[:error] = 'Access Denied !!!'
      redirect_to root_path
    end
  end

  def profile?
    if current_user.is_client? && current_user.profile.nil?
      redirect_to create_profile_client_profile_path(current_user)
    end
  end
end
