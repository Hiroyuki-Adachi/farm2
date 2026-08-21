class IpListsController < ApplicationController
  layout false
  skip_before_action :authenticate_user!, only: %i[new create edit update]
  before_action :set_return_to
  before_action :check_ip_access!
  before_action :set_ip, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    user = User.find_by(login_name: params[:login_name])
    unless user
      IpList.block_ip!(request.remote_ip)
      return to_error_path
    end

    return to_error_path unless user.otp_enabled || user.linable? || user.mailable?

    ip = IpList.white_ip!(request.remote_ip, user)
    if deliver_authentication_token?(user, ip)
      redirect_to edit_ip_list_path(ip, return_to: @return_to)
    else
      ip.destroy
      to_error_path
    end
  end

  def update
    if @ip.created_user.otp_enabled
      return redirect_to new_ip_list_path(return_to: @return_to) unless @ip.created_user.totp_verify?(params[:token])
    elsif !@ip.authenticate?(params[:token])
      return redirect_to new_ip_list_path(return_to: @return_to)
    end
    @ip.updated_expired_on
    log_in(@ip.created_user, target: login_target_for_return_to)
    redirect_to @return_to.presence || menu_index_path
  end

  private

  def deliver_authentication_token?(user, ip)
    return true if user.otp_enabled
    return line_push_message?(user, ip) if user.linable?

    UserMailer.ip_confirmation(ip, ip.token).deliver_later
    true
  end

  def line_push_message?(user, ip)
    message = I18n.t('line_authentication', token: ip.token)
    LineHookService.push_message(user.line_id, message, retry_key: SecureRandom.uuid).is_a?(Net::HTTPSuccess)
  end

  def check_ip_access!
    if IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }
      redirect_to @return_to.presence || root_path and return
    elsif IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path and return
    end
  end

  def set_ip
    @ip = IpList.find_valid(params[:id], request.remote_ip)
    to_error_path and return unless @ip
  end

  def set_return_to
    @return_to = safe_return_to_path(params[:return_to], allowed_path_prefixes: ["/tablets"])
  end

  def login_target_for_return_to
    return :TB if @return_to&.start_with?("/tablets")

    :PC
  end
end
