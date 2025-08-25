class IpListsController < ApplicationController
  layout false
  before_action :set_ip, only: [:update]

  def new
    # PCタブ専用の一時レコードを作成
    @qr = QrLoginRequest.create!(
      user_agent: request.user_agent,
      ip: request.remote_ip
    )

    # このタブ専用のnonce（念押し）
    pc_nonce = cookies.encrypted[:pc_nonce] ||= SecureRandom.hex(16)
    @qr.update!(pc_nonce: pc_nonce)

    # スマホに渡す短いJSON（id は signed_id）
    @payload_json = {
      v: 1,
      t: "login",
      id: @qr.signed_id(purpose: :qr_login, expires_in: (@qr.expires_at - Time.current).to_i)
    }.to_json
  end

  def create
    user = User.find_by(login_name: params[:login_name])
    unless user
      IpList.block_ip!(request.remote_ip)
      return to_error_path
    end

    unless user.linable?
      return to_error_path
    end

    ip = IpList.white_ip!(request.remote_ip, user)
    if LineHookService.push_message(user.line_id, I18n.t('line_authentication', token: ip.token)).is_a?(Net::HTTPSuccess)
      redirect_to edit_ip_list_path(ip)
    else
      ip.destroy
      return to_error_path
    end
  end

  def edit
    qr = QrLoginRequest.find(params[:id])
    payload_json = {
      v: 1,
      t: "login",
      id: qr.signed_id(purpose: :qr_login, expires_in: (qr.expires_at - Time.current).to_i)
    }.to_json
    png = RQRCode::QRCode.new(payload_json).as_png(size: 320, border_modules: 2).to_s
    send_data png, type: "image/png", disposition: "inline"
  end

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
