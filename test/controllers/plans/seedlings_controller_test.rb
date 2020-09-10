require 'test_helper'

class Plans::SeedlingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end
end
