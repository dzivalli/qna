require "application_responder"

class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def not_authorized
    # redirect_to root_path, alert: 'Not authorized' && return unless request.xhr?
    render json: nil, status: :unauthorized
  end
end
