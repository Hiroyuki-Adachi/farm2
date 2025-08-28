class PersonalInformations::ScansController < PersonalInformationsController
  before_action :decode_and_normalize!, only: [:create]

  def new; end

  def create
    # JSONで、かつ "type" キーが必須
    return render json: { error: "Invalid QR payload", message: 'QRコードの内容が不正です' }, status: :unprocessable_content unless @data.is_a?(Hash) && @data.key?(:type)

    case @data[:type]
    when "lands" then return handle_lands
    when "login" then return handle_login
    else
      return render json: { error: "Unsupported type", message: 'サポートされていないQRコードです' }, status: :bad_request
    end
  end

  private

  def decode_and_normalize!
    raw = params[:payload]

    case raw
    when String
      begin
        raw = JSON.parse(raw, symbolize_names: true)
      rescue JSON::ParserError
        return render json: { error: "Malformed JSON payload", message: "QRコードの内容が不正です" },
                      status: :unprocessable_entity
      end
    when ActionController::Parameters, Hash
      raw = raw.to_unsafe_h if raw.is_a?(ActionController::Parameters)
      raw = raw.deep_symbolize_keys
    else
      return render json: { error: "Invalid QR payload", message: "QRコードの内容が不正です" },
                    status: :unprocessable_entity
    end

    @data = {
      version: raw[:v] || raw[:version],
      type: raw[:t] || raw[:type]
    }
    [:id, :token, :value, :exp].each { |k| @data[k] = raw[k] if raw.key?(k) }

    return if @data[:type].present?

    return render json: { error: "Missing type", message: "typeがありません" }, status: :unprocessable_entity
  end

  def handle_lands
    land = Land.find_by(uuid: @data[:value])
    return render json: { action: "error", message: "該当する圃場が見つかりません" }, status: :not_found unless land

    url = personal_information_land_path(personal_information_token: current_user.token, id: land.id)
    render json: { action: "redirect", url: url }, status: :ok
  end

  def handle_login
    qr = QrLoginRequest.find_signed!(@data[:id], purpose: :qr_login)
    return render json: { action: "error", message: "QRの有効期限が切れています" }, status: :gone if qr.expired?
    return render json: { action: "error", message: "このQRは承認できません" }, status: :conflict unless qr.approvable?

    qr.update!(approved_at: Time.current, approved_by: current_user)

    Turbo::StreamsChannel.broadcast_replace_to(
      qr,
      target: ActionView::RecordIdentifier.dom_id(qr, :status),
      partial: "ip_lists/approved",
      locals: { qr: qr }
    )

    render json: { action: "ack", message: "PCにログイン信号を送りました" }, status: :ok
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render json: { action: "error", message: "QRトークンが不正です" }, status: :unprocessable_entity
  end
end
