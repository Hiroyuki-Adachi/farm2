module MailHelper
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
end
