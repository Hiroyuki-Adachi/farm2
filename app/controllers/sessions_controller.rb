class SessionsController < ApplicationController
  layout 'menu'

  def new
  end

  def create
    user = User.find_by(login_name: params[:login_name].downcase)
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to menu_index_path
    else
      flash.now[:danger] = 'IDまたはpasswordが間違っています。'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
