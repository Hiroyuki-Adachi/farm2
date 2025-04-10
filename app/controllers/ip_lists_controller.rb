class IpListsController < ApplicationController
  layout false
  before_action :set_ip, only: [:edit, :update]

  def new; end

  def create
    user = User.find_by_mail(params[:mail])
    if user
      ip = IpList.white_ip!(request.remote_ip, user)
      UserMailer.ip_confirmation(ip, ip.token).deliver_later
      redirect_to edit_ip_list_path(ip)
    else
      IpList.block_ip!(request.remote_ip)
      to_error_path
    end
  end

  def edit; end

  def update
    if @ip.authenticate?(params[:token])
      @ip.updated_expired_on
      log_in(@ip.created_user)
      redirect_to menu_index_path
    else
      redirect_to new_ip_list_path
    end
  end

  private

  def restrict_remote_ip
    if IpList::LOCAL_ADDRESSES.any? { |ip| ip.include?(IPAddr.new(request.remote_ip)) }
      redirect_to root_path 
      return
    elsif IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }
      redirect_to root_path
      return
    elsif IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path
      return
    end
  end

  def set_ip
    @ip = IpList.where("current_timestamp <= confirmation_expired_at")
      .where(expired_on: nil)
      .find_by(id: params[:id], ip_address: request.remote_ip, white_flag: true)
    to_error_path unless @ip
  end
end
