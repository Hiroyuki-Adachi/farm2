require "test_helper"

class PersonalInformations::MapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "地図" do
    get personal_information_maps_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "地図に他組織の土地を表示しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")
    LandCost.find_or_create_by!(land: other_land, activated_on: Date.new(1900, 1, 1)) do |cost|
      cost.work_type = work_types(:work_type_koshi)
    end

    get personal_information_maps_path(personal_information_token: @user.token)

    assert_response :success
    assert_select "input#land_#{other_land.id}", count: 0
  end
end
