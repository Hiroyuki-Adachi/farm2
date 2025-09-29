class Users::MailsController < ApplicationController
  before_action :set_user, only: [:new, :create]

  helper MailHelper

  def new; end

  def create
    if @user.update(user_params)
      UserMailer.email_confirmation(@user).deliver_later
      redirect_to menu_index_path, notice: 'メールを送信しました。メール内のリンクをクリックしてメールアドレスの変更を完了してください'
    else
      render :new, status: :unprocessable_content, alert: 'メールアドレスの変更に失敗しました'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.expect(user: [:mail])
  end
end
