Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV.fetch('GOOGLE_CLIENT_ID'), ENV.fetch('GOOGLE_CLIENT_SECRET'), {
    scope: 'email,https://mail.google.com/',
    access_type: 'offline',
    prompt: 'consent'
  }
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = "#{Rails.application.config.relative_url_root}/auth"
