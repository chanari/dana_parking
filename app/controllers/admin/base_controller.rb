class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :is_admin?
  before_action :set_admin

  private

  def is_admin?
    unless current_user.role == '2'
      flash[:error] = 'Access Denied !!!'
      redirect_to root_path
    end
  end

  def set_admin
    @admin = User.includes(:profile).where(id: current_user.id).take
  end
end
