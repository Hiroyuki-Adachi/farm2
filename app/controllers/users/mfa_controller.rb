class Users::MfaController < ApplicationController
  def new
    current_user.prepare_totp_secret!
    @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name)
  end

  def create
    if current_user.totp.verify(params[:otp], drift_behind: 30, drift_ahead: 30)
      current_user.enable_totp!
      redirect_to menu_index_path, notice: "2段階認証が有効になりました。"
    else
      @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name)
      render :new, status: :unprocessable_content, alert: '無効なOTPです。'
    end
  end
end
