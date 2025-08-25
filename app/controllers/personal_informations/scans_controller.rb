class PersonalInformations::ScansController < PersonalInformationsController
  before_action :decode_params, only: [:create]

  def new; end

  def create
    # JSONで、かつ "type" キーが必須
    return render json: { error: "Invalid QR payload", message: 'QRコードの内容が不正です' }, status: :unprocessable_content unless @data.is_a?(Hash) && @data.key?(:type)

    case @data[:type]
    when 'lands'
      land = Land.find_by(uuid: @data[:value])
      return render json: { error: 'Record Not found', message: '該当する圃場が見つかりません' }, status: :not_found unless land

      redirect_url = personal_information_land_path(personal_information_token: current_user.token, id: land.id)
    else
      return render json: { error: "Unsupported type", message: 'サポートされていないタイプです' }, status: :bad_request
    end

    # 成功 → フロントで Turbo.visit できるようにURLを返す
    render json: { redirect_url: redirect_url }, status: :ok
  end

  private

  def decode_params
    payload = params[:payload].to_s
    begin
      @data = JSON.parse(payload, symbolize_names: true)
    rescue JSON::ParserError
      return render json: { error: "Malformed JSON payload", message: 'QRコードの内容が不正です' }, status: :unprocessable_content
    end

    # v と version、t と type を統一する
    unified = {}

    # version
    unified[:version] = raw.key?(:v) ? raw[:v] : raw[:version]

    # type
    unified[:type] = raw.key?(:t) ? raw[:t] : raw[:type]

    # その他はそのままコピー（token/value/idなど）
    [:id, :token, :value, :exp].each do |k|
      unified[k] = raw[k] if raw.key?(k)
    end

    @data = unified
  end
end
