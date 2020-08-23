require 'sessions_helper.rb'

module ApplicationHelper
  include SessionsHelper

  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(ar)
    render(partial: "error_templete", :locals => {:ar => ar}) if ar && ar.errors.any?
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
    qr = ::RQRCode::QRCode.new(current_organization.try(:url).to_s + text)
    ChunkyPNG::Image.from_datastream(qr.as_png.resize(300, 300).to_datastream).to_data_url
  end

  def hhmm(hours, count = 1)
    Time.at((hours || 0) * 3600 / count).utc.strftime("%H:%M")
  end

  def work_type_icon_tag(work_type)
    image_tag(work_type.icon ? show_icon_work_type_path(work_type) : "/images/works/default.png", size: "48x48")
  end
end
