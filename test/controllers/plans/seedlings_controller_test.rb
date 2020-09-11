require 'test_helper'

class Plans::SeedlingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end
end
