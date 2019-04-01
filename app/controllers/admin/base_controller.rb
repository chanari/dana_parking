class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :is_admin?

  private

  def is_admin?
    unless current_user.role == '2'
      flash[:error] = 'Access Denied !!!'
      redirect_to root_path
    end
  end
end
