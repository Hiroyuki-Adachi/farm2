class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_term
  
  private
  def set_term
    if session[:term]
      @term = session[:term]
    else
      @term = Organization.first.term
      session[:term] = @term
    end
  end
end
