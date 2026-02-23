require 'sessions_helper'

module ApplicationHelper
  include SessionsHelper

  def hbr(text)
    return simple_format(h(text))
  end

  def error_print(record)
    render(partial: "error_template", :locals => {:ar => record}) if record&.errors&.any?
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

  def qrcode_session_tag(token)
    payload = {
      type: "session",
      value: token,
      version: 1
    }
    qr = ::RQRCode::QRCode.new(payload.to_json)
    ChunkyPNG::Image.from_datastream(qr.as_png.resize(300, 300).to_datastream).to_data_url
  end

  def hhmm(hours, count = 1)
    Time.at((hours || 0) * 3600 / count).utc.strftime("%H:%M")
  end

  def chemical_name(chemical)
    chemical.url.present? ? link_to(chemical.name, chemical.url, target: :_blank, rel: "noopener noreferrer") : chemical.name
  end

  def show_topic(content)
    h(content).gsub(/(?<=\u3000)/, '<br />　')&.html_safe
  end

  def enum_options_for(model_class, attr_name, exclude_keys = [])
    exclude_keys = Array(exclude_keys).map(&:to_s)

    model_class.send(attr_name.to_s.pluralize).keys
      .reject { |key| exclude_keys.include?(key) }
      .map do |key|
        [
          I18n.t("activerecord.enums.#{model_class.model_name.i18n_key}.#{attr_name.to_s.pluralize}.#{key}"),
          key
        ]
      end
  end
end
