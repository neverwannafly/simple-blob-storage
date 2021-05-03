class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:user) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :commit)
    end
  end
end
