require "test_helper"
require "capybara/cuprite"
require "capybara/rails"

REMOTE_CHROME_URL = ENV.fetch("CHROME_URL", nil)
REMOTE_CHROME_HOST, REMOTE_CHROME_PORT =
  if REMOTE_CHROME_URL
    URI.parse(REMOTE_CHROME_URL).then do |uri|
      [uri.host, uri.port]
    end
  end

# リモートのChromeが実行中かどうかをチェック
remote_chrome =
  begin
    if REMOTE_CHROME_URL.nil?
      false
    else
      Socket.tcp(REMOTE_CHROME_HOST, REMOTE_CHROME_PORT, connect_timeout: 1).close
      true
    end
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
    false
  end

remote_options = remote_chrome ? { url: REMOTE_CHROME_URL } : {}

Capybara.register_driver(:better_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    browser_options: remote_chrome ? { "no-sandbox" => nil } : {},
    inspector: true, **remote_options
  )
end

Capybara.server_host = "0.0.0.0"
Capybara.default_normalize_ws = true
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
Capybara.app_host = "http://#{ENV.fetch('APP_HOST', `hostname`.strip&.downcase || '0.0.0.0')}"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :better_cuprite
end
