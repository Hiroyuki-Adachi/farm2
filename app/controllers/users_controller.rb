class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
    @user.worker_id = params[:worker_id]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to edit_worker_path(@user.worker_id)
    else
      render action: :new
    end
  end

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
    return params.require(:user).permit(:login_name, :password, :password_confirmation, :worker_id)
  end
end
