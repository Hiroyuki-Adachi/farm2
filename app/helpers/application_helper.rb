module ApplicationHelper
  GLOBAL_URL = "http://shimodekisu-farm.mydns.jp/"

  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(ar)
    render(partial: "error_templete", :locals => { :ar => ar }) if ar.errors.any?
  end

  def data_print(data, kind, url)
    if data.empty?
      kind
    else
      content_tag(:span, class: "border border-info text-info h5 hover", style: "cursor: default", "data-url" => url) do
        kind
      end
    end
  end

  def qrcode_tag(text)
    qr = ::RQRCode::QRCode.new(GLOBAL_URL + text)
    ChunkyPNG::Image.from_datastream(qr.as_png.resize(300, 300).to_datastream).to_data_url
  end
end
