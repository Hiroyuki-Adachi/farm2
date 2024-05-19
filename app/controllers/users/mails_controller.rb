class Users::MailsController < ApplicationController
  before_action :set_user, only: [:new, :create]

  def new
  end

  def create
    if @user.update(user_params)
      UserMailer.email_confirmation(@user).deliver_later
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:mail)
  end
end
