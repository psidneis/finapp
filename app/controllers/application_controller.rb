require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  self.responder = ApplicationResponder
  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  private 
    def user_not_authorized
     flash[:error] = 'Você não tem permissão para fazer esta ação'
     redirect_to(request.referrer || root_path)
    end

    def configure_permitted_parameters
      ## To permit attributes while registration i.e. sign up (app/views/devise/registrations/new.html.erb)
      devise_parameter_sanitizer.for(:sign_up) << :name# << :attrb2 

      ## To permit attributes while editing a registration (app/views/devise/registrations/edit.html.erb)
      devise_parameter_sanitizer.for(:account_update) << :name
    end
end
