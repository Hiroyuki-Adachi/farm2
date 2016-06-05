class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_term
  
  private
  def set_term
    if session[:organization]
      @organization = session[:organization]
    else
      @organization = Organization.first
    end
    @term = @organization.term
  end
end
