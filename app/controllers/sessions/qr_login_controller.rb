class Sessions::QrLoginController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create, :qrcode, :consume]

  def create
    qr_login_session = QrLoginSession.create!

    render json: {
      token: qr_login_session.token,
      expires_at: qr_login_session.expires_at.iso8601
    }
  end

  def qrcode
    token = params[:token]
    qr_login_session = QrLoginSession.find_by!(token: token)
    head :gone and return if qr_login_session.expired?

    payload = {
      t: "session",
      val: token,
      v: 1
    }

    svg = RQRCode::QRCode.new(payload.to_json).as_svg(offset: 0, shape_rendering: "crispEdges", module_size: 6)
    render plain: svg, content_type: "image/svg+xml"
  end

  def consume
    qr = QrLoginSession.find_by!(token: params[:token])

    return render json: { ok: false, message: "期限切れです" }, status: :gone if qr.expired?
    return render json: { ok: false, message: "未承認です" }, status: :conflict unless qr.approved?

    user = nil

    qr.with_lock do
      # ロック内で再チェック（並行実行対策）
      qr.reload
      return render json: { ok: false, message: "期限切れです" }, status: :gone if qr.expired?
      return render json: { ok: false, message: "未承認です" }, status: :conflict unless qr.approved?
      return render json: { ok: false, message: "すでに使用済みです" }, status: :conflict if qr.consumed?

      user = User.find_by(id: qr.user_id)
      return render json: { ok: false, message: "ユーザーが見つかりません" }, status: :unprocessable_content unless user

      qr.update!(status: :consumed, consumed_at: Time.current)
    end

    reset_session
    session[:user_id] = user.id

    render json: { ok: true, action: "redirect", url: menu_index_path }
  end
end
