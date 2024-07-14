class Sessions::QrController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create]

  def create
    user_token = UserToken.find_by(token: params[:qr_code]) # 例としてQRコードで認証
    if user_token && user_token.user && !user_token.expired?
      log_in(user_token.user)
      Rails.application.config.access_logger.info "TB-#{user_token.user.worker.name}"
      return render json: { success: true }
    else
      return render json: { success: false, message: 'Authentication failed' }, status: :unauthorized
    end
  end
end
