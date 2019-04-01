class ApplicationController < ActionController::Base
  layout :layout_by_resource

  protected

  def after_sign_in_path_for(resource)
    dashboard = { '0' => client_booking_index_path, '2' => admin_booking_index_path }
    dashboard[current_user.role]
  end

  private

  def layout_by_resource
    if devise_controller?
      "home"
    end
  end
end
