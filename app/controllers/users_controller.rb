class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @workers = WorkerDecorator.decorate_collection(Worker.includes(:user).usual.page(params[:page]))
  end

  def new
    @user = User.new
    @user.worker_id = params[:worker_id]
  end

  def create
    @user = User.new(user_params.merge(organization_id: current_organization.id, permission_id: Permission::VISITOR.id))
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

  def user_params
    params.require(:user).permit(:login_name, :password, :password_confirmation, :worker_id)
  end
end
