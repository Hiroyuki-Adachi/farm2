ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup_ip
    @request = ActionController::TestRequest.create
    @request.remote_addr = "127.0.0.1"
    session[:user_id] = 1
  end
end
