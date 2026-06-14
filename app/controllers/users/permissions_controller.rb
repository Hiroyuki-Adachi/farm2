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
    @user = User.find_by(id: params[:user_id], organization_id: current_organization.id)
    to_error_path if @user.blank?
  end

  def user_params
    params.expect(user: [:permission_id])
  end
end
