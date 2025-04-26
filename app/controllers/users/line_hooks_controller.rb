class Users::LineHooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :restrict_remote_ip

  def create
  end
end
