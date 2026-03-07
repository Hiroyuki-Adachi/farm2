class Tablets::SessionsController < TabletsController
  include IpRestrictedLogin
  layout false

  def new
    log_out
  end

  private

  def restrict_remote_ip
    require_ip_whitelist!(return_to: tablets_menu_index_path)
  end
end
