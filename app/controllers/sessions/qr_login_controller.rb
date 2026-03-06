class Sessions::QrLoginController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:create, :qrcode, :consume]

  def create
    qr_login_session = QrLoginSession.create!

    render json: {
      token: qr_login_session.token,
      expires_at: qr_login_session.expires_at.iso8601
    }
  end

  def qrcode
    token = params[:token]
    qr_login_session = QrLoginSession.find_by!(token: token)
    head :gone and return if qr_login_session.expired?

    payload = {
      t: "session",
      val: token,
      v: 1
    }

    svg = RQRCode::QRCode.new(payload.to_json).as_svg(offset: 0, shape_rendering: "crispEdges", module_size: 6)
    render plain: svg, content_type: "image/svg+xml"
  end

  def consume
    qr = QrLoginSession.find_by!(token: params[:token])

    return render json: { ok: false, message: "期限切れです" }, status: :gone if qr.expired?
    return render json: { ok: false, message: "未承認です" }, status: :conflict unless qr.approved?

    user = nil

    qr.with_lock do
      # ロック内で再チェック（並行実行対策）
      qr.reload
      return render json: { ok: false, message: "期限切れです" }, status: :gone if qr.expired?
      return render json: { ok: false, message: "未承認です" }, status: :conflict unless qr.approved?
      return render json: { ok: false, message: "すでに使用済みです" }, status: :conflict if qr.consumed?

      user = User.find_by(id: qr.user_id)
      return render json: { ok: false, message: "ユーザーが見つかりません" }, status: :unprocessable_content unless user

      qr.update!(status: :consumed, consumed_at: Time.current)
    end

    reset_session
    log_in(user, target: access_log_target)
    render json: { ok: true, action: "redirect", url: redirect_path }
  end

  private

  def redirect_path
    safe_redirect_to_path(params[:redirect_to]) || normalize_internal_path(menu_index_path)
  end

  def safe_redirect_to_path(path)
    return if path.blank?

    uri = URI.parse(path)
    return unless uri.scheme.nil? && uri.host.nil?
    normalized_path = strip_script_name_prefix(uri.path)
    return unless normalized_path.start_with?("/tablets")

    safe_path = add_script_name_prefix(normalized_path)
    [safe_path, uri.query].compact.join("?")
  rescue URI::InvalidURIError
    nil
  end

  def access_log_target
    redirect = safe_redirect_to_path(params[:redirect_to]).to_s
    redirect_path = redirect.split("?", 2).first
    normalized_path = strip_script_name_prefix(redirect_path)
    return :TB if normalized_path.start_with?("/tablets")
    return :SP if normalized_path.start_with?("/personal_informations")

    :PC
  end

  def strip_script_name_prefix(path)
    path = path.to_s
    return path if path.blank? || path == "/"

    base_path_prefixes.each do |prefix|
      return path.delete_prefix(prefix) if path == prefix || path.start_with?("#{prefix}/")
    end

    path
  end

  def add_script_name_prefix(path)
    path = path.to_s
    prefix = preferred_base_path_prefix
    return path if prefix.blank?
    return path if path == prefix || path.start_with?("#{prefix}/")

    "#{prefix}#{path.start_with?("/") ? path : "/#{path}"}"
  end

  def normalized_script_name
    script_name = request.script_name.to_s
    normalize_path_prefix(script_name)
  end

  def normalized_relative_url_root
    normalize_path_prefix(Rails.application.config.relative_url_root)
  end

  def preferred_base_path_prefix
    normalized_script_name.presence || normalized_relative_url_root.presence
  end

  def base_path_prefixes
    [normalized_script_name, normalized_relative_url_root].reject(&:blank?).uniq
  end

  def normalize_path_prefix(path)
    path = path.to_s
    return "" if path.blank? || path == "/"

    path = "/#{path}" unless path.start_with?("/")
    path.delete_suffix("/")
  end

  def normalize_internal_path(path)
    path = path.to_s
    return "/" if path.blank?

    path.start_with?("/") ? path : "/#{path}"
  end
end
