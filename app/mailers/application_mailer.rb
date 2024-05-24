class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['MAIL_NAME']} <#{ENV['MAIL_ADDRESS']}>"
  layout 'mailer'
end
