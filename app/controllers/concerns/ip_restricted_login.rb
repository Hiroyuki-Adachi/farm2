module IpRestrictedLogin
  extend ActiveSupport::Concern

  private

  def require_ip_whitelist!(return_to: nil)
    return false unless reject_blacklisted_ip!
    return true if IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }

    redirect_params = {}
    redirect_params[:return_to] = return_to if return_to.present?
    redirect_to new_ip_list_path(redirect_params)
    false
  end

  # ホワイトリスト検証自体は不要でも、繰り返し不正確認を試みたIP(ブラックリスト)だけは弾きたい場合に使う
  def reject_blacklisted_ip!
    return true unless IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }

    to_error_path
    false
  end
end
