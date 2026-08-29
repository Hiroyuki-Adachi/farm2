class Tablets::QrLoginController < TabletsController
  include IpRestrictedLogin
  include QrLoginActions

  before_action :check_login_ip_access!

  private

  # タブレットは電話回線利用が多くIPが不安定なため、ホワイトリスト検証は行わない(#1173)。
  # ただし不正確認試行を繰り返したブラックリストIPだけは引き続き拒否する。
  def check_login_ip_access!
    reject_blacklisted_ip!
  end

  # ログイン先はredirect_toの値に関わらず常にTB固定とし、PCターゲットを騙し取れないようにする。
  def login_target
    :TB
  end

  def allowed_redirect_prefix
    "/tablets"
  end

  def default_redirect_path
    tablets_menu_index_path
  end
end
