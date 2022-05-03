class SessionsController < ApplicationController

  def index
    log_out
    redirect_to root_path
  end

  def new
    log_out
  end

  def create
    user = User.find_by(login_name: params[:login_name].downcase)
    if user && user.authenticate(params[:password])
      log_in(user)
      Rails.application.config.access_logger.info "PC-#{user.worker.name}"
      redirect_to menu_index_path
    else
      flash.now[:danger] = 'IDまたはpasswordが間違っています。'
      render :new
    end
  end
end
