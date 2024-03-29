require 'test_helper'
class MenuControllerTest < ActionController::TestCase
  def setup
    setup_ip
    @organization = Organization.find(1)
    @system = System.find_by(term: @organization.term, organization_id: @organization.id)
  end

  test "メニュー表示" do
    get :index
    assert_response :success
  end

  test "集計対象期間変更画面表示" do
    get :edit, params: {id: @system}
    assert_response :success
  end

  test "対象年度変更画面表示" do
    get :edit_term, params: {id: @system}
    assert_response :success
  end

  test "対象年度変更(実行:新規)" do
    new_term = systems(:s2015).term + 1
    System.where(term: new_term).destroy_all
    assert_difference('System.count', 1) do
      patch :update, params: {id: @system, system: {term: new_term}}
    end
    assert_equal Organization.first.term, new_term
    assert_equal User.find(session[:user_id]).term, new_term
    assert_equal User.find(2).term, new_term
  end

  test "対象年度変更(実行:既存)(管理者)" do
    now_term = systems(:s2014).term
    old_term = systems(:s2015).term
    assert_no_difference('System.count') do
      patch :update, params: {id: @system, system: {term: now_term}}
    end
    assert_equal Organization.first.term, old_term
    assert_equal User.find(session[:user_id]).term, now_term
    assert_equal User.find(2).term, old_term
  end

  test "対象年度変更(実行:既存)(管理者以外)" do
    session[:user_id] = users(:user_user).id
    old_term = systems(:s2015).term
    now_term = systems(:s2014).term
    assert_no_difference('System.count') do
      patch :update, params: {id: @system, system: {term: now_term}}
    end
    assert_equal Organization.first.term, old_term
    assert_equal User.find(users(:users1).id).term, old_term
    assert_equal User.find(users(:user_user).id).term, now_term
  end

  def teardown
    User.update_all(term: systems(:s2015).term)
    Organization.update_all(term: systems(:s2015).term)
  end
end
