class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  PERMIT_ADDRESSES = ['127.0.0.1', '192.168.', '10.8.0.'].freeze

  before_action :set_term
  before_action :restrict_remote_ip

  private

  def set_term
    if session[:organization]
      @organization = Organization.new(session[:organization])
    else
      @organization = Organization.first
      session[:organization] = @organization.attributes
    end
    @term = @organization.term
  end

  def restrict_remote_ip
    unless PERMIT_ADDRESSES.any? { |pa| request.remote_ip.start_with?(pa)}
      render text: 'Service Unavailable', status: 503
    end
  end
end
