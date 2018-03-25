class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to menu_index_path
    else
      render action: :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    return params.require(:user).permit(:login_name, :password, :password_confirmation)
  end
end
