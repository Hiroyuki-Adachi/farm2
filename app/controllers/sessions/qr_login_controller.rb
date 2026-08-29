class Sessions::QrLoginController < ApplicationController
  include IpRestrictedLogin
  include QrLoginActions

  before_action :check_login_ip_access!

  private

  def check_login_ip_access!
    require_ip_whitelist!
  end
end
