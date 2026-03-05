class Tablets::SessionsController < ApplicationController
  layout false
  skip_before_action :restrict_remote_ip, only: [:new]

  def new
    log_out
  end
end
