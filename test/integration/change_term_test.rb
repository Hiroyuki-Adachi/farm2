require 'test_helper'

class ChangeTermTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.find_by(id: 1)
    @organization.term = systems(:s2017).term
    @organization.save
    @system = System.find_by(term: @organization.term, organization_id: @organization.id)
  end

  test "対象年度変更(実行:新規)" do
    post sessions_path, params: {login_name: "1234567890", password: "password"}
    follow_redirect!
    assert_response :success

    new_term = systems(:s2017).term + 1
    assert_difference('System.count', 1) do
      patch menu_path(@system), params: {system: {term: new_term}}
    end
    follow_redirect!
    assert_response :success

    get menu_index_path
    assert_response :success
    assert_equal new_term, assigns(:term)
  end

  def teardown
    @organization.save
  end
end
