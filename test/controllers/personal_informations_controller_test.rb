require 'test_helper'

class PersonalInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報" do
    get personal_information_path(token: @user.token)
    assert_response :success
  end

  test "個人情報のmanifest" do
    get manifest_personal_information_path(token: @user.token)

    assert_response :success
    assert_equal "application/manifest+json", response.media_type

    manifest = JSON.parse(response.body)
    assert_equal personal_information_path(token: @user.token), manifest["start_url"]
    assert_equal personal_information_path(token: @user.token), manifest["scope"]
    assert_equal "standalone", manifest["display"]
    assert_equal ["/images/icons/farm2-192.png", "/images/icons/farm2-512.png"], manifest["icons"].map { |icon| icon["src"] }
  end
end
