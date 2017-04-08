class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_term

  def clear_caches(term)
    Rails.cache.delete(sum_hours_key(term))
    Rails.cache.delete(count_workers_key(term))
  end

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
end
