require Rails.root.join('lib/gmail_authorizer')

module ActionMailer
  class Base
    private

    def deliver_mail(headers = {}, &block)
      if smtp_settings[:authentication] == :xoauth2
        self.smtp_settings[:password] = GmailAuthorizer.authorize.access_token
      end
      super
    end
  end
end
