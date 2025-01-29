require 'sessions_helper'

module ApplicationHelper
  include SessionsHelper

  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(record)
    render(partial: "error_templete", :locals => {:ar => record}) if record&.errors&.any?
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

  def chemical_name(chemical)
    chemical.url.present? ? link_to(chemical.name, chemical.url, target: :_blank, rel: "noopener noreferrer") : chemical.name
  end

  def show_topic(content)
    h(content).gsub(/(?<=\u3000)/, '<br />　')&.html_safe
  end

  def enum_options_for_select(klass, attr_name)
    klass.send(attr_name.to_s.pluralize).keys.map { [klass.human_attribute_enum_value(attr_name, it), it] }.to_h
  end
end
