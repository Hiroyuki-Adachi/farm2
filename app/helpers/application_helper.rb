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

  def hhmm(hours, count = 1)
    Time.at((hours || 0) * 3600 / count).utc.strftime("%H:%M")
  end

  def work_type_icon_tag(work_type)
    work_type.icon ? tag.img(src: show_icon_work_type_path(work_type), height: 48, width: 48) : image_tag("/images/works/default.png", size: "48x48")
  end

  def chemical_name(chemical)
    chemical.url.present? ? link_to(chemical.name, chemical.url, target: :_blank, rel: "noopener noreferrer") : chemical.name
  end

  def show_topic(content)
    h(content).gsub(/(?<=\u3000)/, '<br />　')&.html_safe
  end

  def mail_status_badge(user)
    status = user.current_mail_status

    label, color = case status
    when :confirmed
      ["認証済み", :success]
    when :pending
      ["認証待ち", :warning]
    when :expired
      ["期限切れ", :danger]
    when :not_entered
      ["未入力", :secondary]
    else
      ["不明", :dark]
    end

    content_tag(:span, label, class: "badge bg-#{color}")
  end

  def enum_options_for(model_class, attr_name)
    model_class.send(attr_name.to_s.pluralize).keys.map do |key|
      [
        I18n.t("activerecord.attributes.#{model_class.model_name.i18n_key}.#{attr_name.to_s.pluralize}.#{key}"),
        key
      ]
    end
  end
end
