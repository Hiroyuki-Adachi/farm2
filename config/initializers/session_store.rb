# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_farm2_session', path: Rails.env.production? ? '/farm2' : '/'
