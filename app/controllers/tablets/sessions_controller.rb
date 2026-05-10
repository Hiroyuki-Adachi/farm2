class Tablets::SessionsController < TabletsController
  include IpRestrictedLogin
  layout false
  skip_before_action :authenticate_user!
  before_action :check_login_ip_access!

  def new
    log_out
  end

  private

  def check_login_ip_access!
    require_ip_whitelist!(return_to: tablets_menu_index_path)
  end
end
