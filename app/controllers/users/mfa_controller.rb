class Users::MfaController < ApplicationController
  def edit
    return if current_user.otp_enabled
    current_user.prepare_totp_secret!
    @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name)
  end

  def update
    if current_user.totp_verify?(params[:otp])
      current_user.enable_totp!
      redirect_to menu_index_path, notice: "2段階認証が有効になりました。"
    else
      @provisioning_uri = current_user.totp.provisioning_uri(current_user.worker.name)
      flash.now[:alert] = '無効なOTPです。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    current_user.destroy_totp!
    redirect_to edit_users_mfa_path, notice: "2段階認証を無効にしました。"
  end
end
