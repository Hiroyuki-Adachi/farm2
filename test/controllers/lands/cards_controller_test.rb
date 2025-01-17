require 'test_helper'

class Lands::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "土地カルテ(一覧)" do
    get lands_cards_path
    assert_response :success
  end
end
