class Tablets::QrLoginController < TabletsController
  include QrLoginActions

  private

  # タブレットは電話回線利用が多くIPが不安定なため、ホワイトリスト検証を行わない(#1173)。
  # そのためログイン先はredirect_toの値に関わらず常にTB固定とし、PCターゲットを騙し取れないようにする。
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
