class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_permission, only: [:new, :create, :edit, :update]

  def index
    @workers = WorkerDecorator.decorate_collection(Worker.includes(:user).usual.page(params[:page]))
  end

  def new
    @user = User.new
    @user.worker_id = params[:worker_id]
  end

  def create
    @user = User.new(user_params.merge(organization_id: current_organization.id))
    if @user.save
      redirect_to users_path
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to current_user.id == @user.id ? menu_index_path : users_path
    else
      render action: :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_permission
    @permissions = Permission.all
  end

  def user_params
    if current_user.admin?
      params.require(:user).permit(:login_name, :password, :password_confirmation, :worker_id, :permission_id)
    else
      params.require(:user).permit(:login_name, :password, :password_confirmation, :worker_id)
    end
  end
end
