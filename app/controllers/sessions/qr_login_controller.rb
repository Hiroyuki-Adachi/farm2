class Sessions::QrLoginController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create, :qrcode]

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
end
