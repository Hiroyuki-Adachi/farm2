class QrLoginSessionsController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create, :qrcode]

  def create
    qr_login_session = QrLoginSession.create!

    render json: {
      token: qr_login_session.token,
      expires_at: qr_login_session.expires_at.iso8601
    }
  end

  def qrcode
    qr_login_session = QrLoginSession.find_by!(token: params[:token])
    return head :gone if qr_login_session.expired?

    qr = RQRCode::QRCode.new(qr_payload(qr_login_session))
    svg = qr.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )

    render plain: svg, content_type: 'image/svg+xml'
  end

  private

  def qr_payload(qr_login_session)
    qr_login_session.token
  end
end
