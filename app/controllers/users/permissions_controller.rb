class Users::PermissionsController < ApplicationController
  before_action :set_user

  def new; end

  def create
    if @user.update(user_params)
      redirect_to users_path
    else
      render action: :new
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_params
    params.expect(user: [:permission_id])
  end
end
