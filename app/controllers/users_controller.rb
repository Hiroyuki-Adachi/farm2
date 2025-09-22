class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :permit_admin, only: [:index, :new, :create, :destroy]
  before_action :permit_self, only: [:edit, :update]

  def index
    @workers = WorkerDecorator.decorate_collection(Worker.includes(:user).usual.page(params[:page]))
  end

  def new
    @user = User.new
    @user.worker_id = params[:worker_id]
  end

  def create
    @user = User.new(
      user_params.merge(
        organization_id: current_organization.id,
        permission_id: :visitor,
        term: current_term
      )
    )
    if @user.save
      redirect_to users_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to current_user.id == @user.id ? menu_index_path : users_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [:login_name, :password, :password_confirmation, :worker_id])
  end

  def permit_self
    to_error_path unless current_user.admin? || current_user.id == @user.id
  end
end
