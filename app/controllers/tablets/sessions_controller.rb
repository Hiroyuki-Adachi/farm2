class Tablets::SessionsController < TabletsController
  layout false
  skip_before_action :authenticate_user!

  def new
    log_out
  end
end
