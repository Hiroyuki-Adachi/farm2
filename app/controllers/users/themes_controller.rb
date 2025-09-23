class Users::ThemesController < ApplicationController
  before_action :set_user

  def new; end

  def create
    if @user.update(user_params)
      redirect_to menu_index_path
    else
      render action: :new
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.expect(user: [:theme])
  end
end
