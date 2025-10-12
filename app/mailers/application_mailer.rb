class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_ADDRESS')
  layout 'mailer'
  before_action :update_smtp_settings, unless: -> { Rails.env.test? }
  
  def update_smtp_settings
    refresh_token = AuthController.read_refresh_token
    Rails.logger.debug { "Using refresh token: #{refresh_token}" }

    client = OAuth2::Client.new(
      Rails.application.credentials.dig(:google_client, :id) || ENV.fetch('GOOGLE_CLIENT_ID'),
      Rails.application.credentials.dig(:google_client, :secret) || ENV.fetch('GOOGLE_CLIENT_SECRET'),
      site: 'https://accounts.google.com',
      authorize_url: '/o/oauth2/auth',
      token_url: '/o/oauth2/token'
    )

    token_hash = {
      refresh_token: refresh_token,
      expires_at: Time.now.to_i + 3600
    }

    token = OAuth2::AccessToken.from_hash(client, token_hash)

    access_token = token.refresh!.token
    Rails.logger.debug { "Generated access token: #{access_token}" }

    ActionMailer::Base.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'gmail.com',
      authentication: :xoauth2,
      user_name: ENV.fetch('MAIL_ADDRESS'),
      password: access_token
    }
  end
end
