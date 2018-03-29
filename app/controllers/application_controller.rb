class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  PERMIT_ADDRESSES = ['127.0.0.1', '192.168.', '10.8.0.'].freeze

  before_action :set_term
  before_action :restrict_remote_ip
  before_action :set_system

  protected

  def sum_hours_key(term)
    "sum_hours#{term}"
  end

  def count_workers_key(term)
    "count_workers#{term}"
  end

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
    if PERMIT_ADDRESSES.none? { |pa| request.remote_ip.start_with?(pa) }
      render text: 'Service Unavailable', status: 503
    elsif session[:user_id].nil? && controller_name != "sessions"
      redirect_to root_path
    end
  end

  def set_system
    cache_key = term_cache_key
    if Rails.cache.exist?(cache_key)
      @system = System.new(Rails.cache.read(cache_key))
    else
      @system = System.find_by(term: @term)
      Rails.cache.write(cache_key, @system.attributes, expires_in: 1.hour)
    end
  end

  def term_cache_key
    "system#{@term}"
  end
end
