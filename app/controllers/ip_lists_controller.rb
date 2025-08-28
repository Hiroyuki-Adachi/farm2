class IpListsController < ApplicationController
  layout false

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
    token = params[:token].to_s
    pc_nonce = cookies.encrypted[:pc_nonce].to_s

    QrLoginRequest.transaction do
      qr = QrLoginRequest.lock.find_by!(token: token)
      return to_error_path if qr.expired?
      return to_error_path if qr.approved_at.nil?
      return to_error_path if qr.used_at.present?

      # 念押し：このタブ本人の確認（pc_nonce を一致確認）
      return to_error_path if qr.pc_nonce.present? && qr.pc_nonce != pc_nonce

      user = qr.approved_by
      unless user
        IpList.block_ip!(qr.ip)
        return to_error_path
      end

      log_in(user) if respond_to?(:sign_in)

      qr.update!(used_at: Time.current)
      IpList.white_ip!(qr.ip, user)
    end

    redirect_to menu_index_path
  rescue ActiveRecord::RecordNotFound
    head :not_found
  rescue => e
    Rails.logger.warn("[qr_create] #{e.class}: #{e.message}")
    head :conflict
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
    if IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }
      redirect_to root_path
      return
    elsif IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path
      return
    end
  end
end
