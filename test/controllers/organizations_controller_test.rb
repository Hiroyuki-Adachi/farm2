require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  fixtures :organizations

  setup do
    @organization = Organization.first
  end

  test "should get edit" do
    get :edit, id: @organization
    assert_response :success
  end

  test "should get update" do
    patch :update, id: @organization, organization: { name: "テスト営農組合" }
    assert_redirected_to root_path
  end

end
