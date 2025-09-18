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
    window_size: [1920, 1080],
    browser_options: remote_chrome ? { "no-sandbox" => nil } : {},
    js_errors: true,
    timeout: 30,
    headless: true,
    **remote_options
  )
end

Capybara.server_host = "0.0.0.0"
Capybara.default_normalize_ws = true
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite
Capybara.app_host = "http://#{ENV.fetch('APP_HOST', `hostname`.strip&.downcase || '0.0.0.0')}"
Capybara.default_max_wait_time = 5

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :better_cuprite, screen_size: [1920, 1080], options: { browser_options: {}, window_size: [1920, 1080] }

  setup do
    WebMock.allow_net_connect!
  end
end

def ensure_wide!(min_width: 1200, height: 900)
  page.driver.resize(min_width, height)
  page.evaluate_script("window.dispatchEvent(new Event('resize'))")
  assert page.has_css?('body', wait: 0.2)
  page.evaluate_script("document.body.getBoundingClientRect().width")
end

def open_nav_if_collapsed
  # すでに desktop サイドバーが表示されていれば何もしない
  return unless page.has_css?('#sidebar_desktop.d-none', visible: :all, wait: 0.2)

  # ボタンをクリックしてオフキャンバスを開く
  find('button[data-bs-target="#sidebar_off_canvas"]', visible: :all).click
  assert_selector '#sidebar_off_canvas.show', wait: 2
end
