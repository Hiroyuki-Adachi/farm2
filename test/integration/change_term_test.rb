require 'test_helper'

class ChangeTermTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.find_by(id: 1)
    @organization.term = systems(:s2017).term
    @organization.save
    @system = System.find_by(term: @organization.term, organization_id: @organization.id)
    @user = users(:users1)
  end

  test "対象年度変更(実行:新規)" do
    post sessions_path, params: {login_name: @user.login_name, password: "password"}
    follow_redirect!
    assert_response :success

    new_term = systems(:s2017).term + 1
    assert_difference('System.count', 1) do
      patch menu_path(@system), params: {system: {term: new_term}}
    end
    follow_redirect!
    assert_response :success

    new_system = System.find_by(term: new_term, organization_id: @organization.id)
    get menu_index_path
    assert_response :success
    assert_select 'h1', /#{new_system.start_date.strftime('%Jy年')}/
  end

  def teardown
    @organization.save
  end
end
