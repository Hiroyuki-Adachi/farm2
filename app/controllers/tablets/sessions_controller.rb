class Tablets::SessionsController < TabletsController
  include IpRestrictedLogin

  layout false
  skip_before_action :authenticate_user!
  before_action :check_login_ip_access!

  def new
    log_out
  end

  private

  # タブレットは電話回線利用が多くIPが不安定なため、ホワイトリスト検証は行わない(#1173)。
  # ただし不正確認試行を繰り返したブラックリストIPだけは引き続き拒否する。
  def check_login_ip_access!
    reject_blacklisted_ip!
  end
end
