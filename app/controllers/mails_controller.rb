class MailsController < ApplicationController
  def new
    render layout: false
  end

  def create
    user = User.find_by_mail(params[:mail])
    if user
      ip = IpList.white_ip!(request.remote_ip, user)
      UserMailer.ip_confirmation(ip).deliver_later
    else
      IpList.block_ip!(request.remote_ip)
    end
    render layout: false
  end

  private

  def restrict_remote_ip
    redirect_to root_path if IpList::LOCAL_ADDRESSES.any? { |ip| ip.include?(IPAddr.new(request.remote_ip)) }
  end
end
