class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    "#{model.family_name[0, 2]}(#{model.first_name[0]})"
  end

  def home_name
    home_name = model.home.name
    home_name += "(#{model.first_name[0]})" unless model.id == model.home.worker_id
    home_name
  end

  def disp_name
    "#{model.name}(#{model.first_phonetic})"
  end

  def permission_name
    model.user ? I18n.t("activerecord.enums.user.permission_ids.#{model.user.permission_id}") : ""
  end

  def login_name
    model.user ? model.user.login_name : ""
  end

  def line_mark
    model.user&.linable? ? "◯" : ""
  end

  def mail_mark
    model.user&.mailable? ? "◯" : ""
  end

  def delivery_mark
    model.user&.topic_delivery_enabled? ? "◯" : ""
  end

  def otp_mark
    model.user&.otp_enabled? ? "◯" : ""
  end
end
