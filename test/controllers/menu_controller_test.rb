require 'test_helper'
class MenuControllerTest < ActionDispatch::IntegrationTest
  def setup
    @organization = Organization.find(1)
    User.where(organization_id: @organization).update_all(term: systems(:s2015).term)
    @user = users(:users1)
    login_as(@user)
    @system = System.find_by(term: @organization.term, organization_id: @organization.id)
  end

  test "メニュー表示" do
    get menu_index_path
    assert_response :success
  end

  test "集計対象期間変更画面表示" do
    get edit_menu_path(@system.id)
    assert_response :success
  end

  test "対象年度変更画面表示" do
    get edit_term_menu_path(@system.id)
    assert_response :success
  end

  test "対象年度変更(実行:新規)" do
    new_term = systems(:s2015).term + 1
    System.where(term: new_term).destroy_all

    assert_difference('System.count', 1) do
      patch menu_path(@system.id), params: {system: {term: new_term}}
    end
    @organization.reload
    assert_equal new_term, @organization.term

    User.all.each do |user|
      assert_equal new_term, user.term
    end

    new_system = System.last
    assert_equal new_term, new_system.term
    assert_equal @organization.id, new_system.organization_id
  end

  test "対象年度変更(実行:既存)(管理者)" do
    now_term = systems(:s2014).term
    old_term = systems(:s2015).term
    assert_no_difference('System.count') do
      patch menu_path(@system.id), params: {system: {term: now_term}}
    end

    @user.reload
    assert_equal now_term, @user.term

    @organization.reload
    assert_equal old_term, @organization.term
    User.where.not(id: @user.id).each do |user|
      assert_equal old_term, user.term
    end
  end

  test "対象年度変更(実行:既存)(管理者以外)" do
    user = users(:user_user)
    login_as(user)
    old_term = systems(:s2015).term
    now_term = systems(:s2014).term
    assert_no_difference('System.count') do
      patch menu_path(@system.id), params: {system: {term: now_term}}
    end

    user.reload
    assert_equal now_term, user.term

    @organization.reload
    assert_equal old_term, @organization.term

    User.where.not(id: user.id).each do |user|
      assert_equal old_term, user.term
    end
  end
end
