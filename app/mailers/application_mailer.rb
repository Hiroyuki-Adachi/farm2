class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_ADDRESS')
  layout 'mailer'
end
