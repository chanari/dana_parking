class Manager::BaseController < ApplicationController
  layout 'manager'

  before_action :authenticate_user!
  before_action :is_manager?

  private

  def is_manager?
    unless current_user.role == '1'
      flash[:error] = 'Access Denied !!!'
      redirect_to root_path
    end
  end
end
