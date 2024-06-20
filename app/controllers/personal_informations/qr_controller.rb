class PersonalInformations::QrController < PersonalInformationsController
  def index
    @current_user.regenerate_token!
    qrcode = RQRCode::QRCode.new(@current_user.user_token.token)

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 10, # 1モジュールあたりのピクセルサイズ
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 320 # 画像の総サイズ（ピクセル）
    )

    # 生成されたPNGデータをBase64にエンコードしてビューに渡す
    @qrcode_svg = Base64.encode64(png.to_s)
  end
end
