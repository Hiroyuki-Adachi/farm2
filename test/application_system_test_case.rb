require "test_helper"
require "capybara/cuprite"

Capybara.server = :puma, { Silent: true } # テスト出力を減らすために Puma サーバーを Silent モードで使用
Capybara.javascript_driver = :cuprite

options = {
  url: 'http://chrome:3333',
  browser_options: { 'no-sandbox': nil }
}

Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, options)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite
end
