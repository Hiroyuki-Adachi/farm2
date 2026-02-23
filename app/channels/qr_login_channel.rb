class QrLoginChannel < ApplicationCable::Channel
  def subscribed
    token = params[:token]
    qr_login_session = QrLoginSession.find_by(token: token)

    # 存在しない / 期限切れ / pending以外は購読拒否（試験でも入れとくと安心）
    reject unless qr_login_session&.pending? && qr_login_session.expires_at > Time.current

    stream_from "qr_login:#{token}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
