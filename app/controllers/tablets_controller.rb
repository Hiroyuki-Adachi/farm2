class TabletsController < ApplicationController
  layout 'tablet'

  def index
    @sections = Section.with_users.usual
    @section_id = params[:section_id] || @sections.first&.id
    @users = User.by_section(@section_id)
  end

  private

  def restrict_remote_ip
    remote_ip = IPAddr.new(request.remote_ip)
    if PERMIT_ADDRESSES.none? { |ip| ip.include?(remote_ip) }
      to_error_path
    elsif session[:user_id].nil? && controller_name != "tablets"
      redirect_to tablets_path
    end
  end
end
