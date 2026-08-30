class Tablets::QrLoginController < TabletsController
  include IpRestrictedLogin
  include QrLoginActions

  # 短時間の許容上限(この件数までは429で拒否するだけ)
  THROTTLE_WINDOW = 1.minute
  THROTTLE_LIMIT = 10
  # 継続的な悪用とみなしブラックリストに加点する上限
  BLOCK_WINDOW = 10.minutes
  BLOCK_LIMIT = 60

  before_action :check_login_ip_access!
  before_action :throttle_create!, only: :create

  private

  # タブレットは電話回線利用が多くIPが不安定なため、ホワイトリスト検証は行わない(#1173)。
  # ただし不正確認試行を繰り返したブラックリストIPだけは引き続き拒否する。
  def check_login_ip_access!
    reject_blacklisted_ip!
  end

  # ホワイトリスト検証を外した分、create連打によるQrLoginSession大量発行を防ぐ(#1176)。
  def throttle_create!
    ip = request.remote_ip

    if QrLoginSession.created_from_ip_since(ip, BLOCK_WINDOW.ago).count >= BLOCK_LIMIT
      IpList.block_ip!(ip)
      to_error_path
      return false
    end

    if QrLoginSession.created_from_ip_since(ip, THROTTLE_WINDOW.ago).count >= THROTTLE_LIMIT
      head :too_many_requests
      return false
    end

    true
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
