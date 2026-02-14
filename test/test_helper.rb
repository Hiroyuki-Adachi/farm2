ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'minitest'
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)

Rails.root.glob("test/support/**/*.rb").sort.each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup_ip
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('127.0.0.1')
    session[:user_id] = 1
  end
end

class ActionDispatch::IntegrationTest
  # Helper method to simulate a logged-in user
  def login_as(user)
    post sessions_path, params: { login_name: user.login_name, password: 'password' } # 認証用のリクエスト
  end

  def logout
    get new_session_path
  end

  # Helper method to set the remote IP address
  def set_remote_ip(ip)
    @remote_ip = ip
  end

  # Overrides the default behavior of IntegrationTest to include the IP address
  def process(action, http_method = :get, **args)
    super(action, http_method, **args.merge(headers: { 'REMOTE_ADDR' => @remote_ip || '127.0.0.1' }))
  end
end
