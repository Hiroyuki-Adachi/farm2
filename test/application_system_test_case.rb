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

def ensure_wide!(min_width: 1200, height: 900, timeout: 2.5)
  deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + timeout

  # まずは従来どおりの手順
  page.current_window.resize_to(min_width, height) rescue nil
  page.driver.resize(min_width, height) rescue nil

  # ← ココが重要：viewport を強制的に上書き
  begin
    page.driver.browser.set_viewport width: min_width, height: height
  rescue => _e
    # Ferrum が古いと未定義のことがあるので握りつぶして続行
  end

  # リサイズイベントで再描画
  page.evaluate_script(<<~JS)
    (function(){ window.dispatchEvent(new Event('resize'));
      return new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(r)));
    })()
  JS

  # 収束待ち
  last_w = nil
  loop do
    last_w = page.evaluate_script("window.innerWidth") || 0
    break if last_w >= (min_width - 4)
    raise "Failed to reach width #{min_width}px (last: #{last_w}px)" if Process.clock_gettime(Process::CLOCK_MONOTONIC) > deadline
    sleep 0.05
  end
  last_w
end

def open_nav_if_collapsed
  # Turboでの初期描画待ち（bodyが来てから）
  assert_selector 'body', wait: 2

  # すでにデスクトップサイドバーが見えているなら何もしない
  return if page.has_css?('#sidebar_desktop', visible: true, wait: 0.5)

  # モバイル向けトグルボタン（Offcanvasトグル）を待つ
  toggler_selectors = [
    'button[data-bs-target="#sidebar_off_canvas"]',  # まずはこれ
    '.navbar .navbar-toggler',                       # 予備（レイアウトによる）
  ]

  toggler = toggler_selectors.find { |sel| page.has_css?(sel, visible: :visible, wait: 1.0) }

  # もし “表示状態の” トグルが見つからない場合：
  #  - 画面幅がまだ狭い（デスクトップがd-noneでモバイルUIが描画待ち）
  #  - 逆に広がって「トグルがd-none」になっている（その場合は開く必要なし）
  unless toggler
    # もう一度、デスクトップサイドバーが見えてこないか少し待つ
    return if page.has_css?('#sidebar_desktop', visible: true, wait: 1.0)

    # どうしてもトグルが可視にならない場合は、非表示でも存在はしていないか確認してデバッグ
    if page.has_css?('button[data-bs-target="#sidebar_off_canvas"]', visible: :all, wait: 0.5)
      raise "Sidebar toggler exists but is not visible (likely d-none at this width)."
    else
      raise "Sidebar toggler not found in DOM."
    end
  end

  find(toggler, visible: :visible).click
  assert_selector '#sidebar_off_canvas.show', wait: 2
end
