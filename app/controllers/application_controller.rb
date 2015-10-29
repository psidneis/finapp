require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
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
end
