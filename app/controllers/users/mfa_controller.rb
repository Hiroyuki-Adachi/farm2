class Users::MfaController < ApplicationController
  def new
    current_user.prepare_totp_secret!
    @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name, issuer: ENV.fetch("OTP_SECRET_ISSUER"))
  end

  def create
    if current_user.totp.verify(params[:otp], drift_behind: 30, drift_ahead: 30)
      current_user.enable_totp!
      redirect_to root_path, notice: "2段階認証が有効になりました。"
    else
      flash.now[:alert] = "無効なOTPです。"
      @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name, issuer: ENV.fetch("OTP_SECRET_ISSUER"))
      render :new
    end
  end
end
