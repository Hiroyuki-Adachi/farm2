require 'test_helper'

class PersonalInformations::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(土地)" do
    get personal_information_lands_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "個人情報(土地)詳細" do
    travel_to Time.zone.local(2015, 10, 1) do
      get personal_information_land_path(personal_information_token: @user.token, id: lands(:land_land_cost1).id)
      assert_response :success
    end
  end
end
