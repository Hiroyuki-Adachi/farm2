module IpRestrictedLogin
  extend ActiveSupport::Concern

  private

  def require_ip_whitelist!(return_to: nil)
    if IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path
      return false
    end
    return true if IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }

    params = {}
    params[:return_to] = return_to if return_to.present?
    redirect_to new_ip_list_path(params)
    false
  end
end
