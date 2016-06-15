require 'test_helper'
class MenuControllerTest < ActionController::TestCase
  setup do
    @organization = Organization.first
    @system = System.find_by(term: @organization.term)
  end

  test "メニュー表示" do
    get :index
    assert_response :success
  end

  test "集計対象期間変更画面表示" do
    get :edit, id: @system
    assert_response :success
  end

  test "対象年度変更画面表示" do
    get :edit_term, id: @system
    assert_response :success
  end
end
