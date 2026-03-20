Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.dig(:google_client, :id) || ENV.fetch('GOOGLE_CLIENT_ID'),
           Rails.application.credentials.dig(:google_client, :secret) || ENV.fetch('GOOGLE_CLIENT_SECRET'), {
             scope: 'email,https://mail.google.com/',
             access_type: 'offline',
             prompt: 'consent'
           }
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.logger = Rails.logger
relative_url_root = Rails.application.config.relative_url_root.to_s
relative_url_root = relative_url_root.sub(%r{/*\z}, "")

OmniAuth.config.path_prefix = [relative_url_root.presence, "auth"].compact.join("/")
