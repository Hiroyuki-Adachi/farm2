require "test_helper"

class Users::WordsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "検索ワード(表示)" do
    get :new
    assert_response :success
  end  
end
