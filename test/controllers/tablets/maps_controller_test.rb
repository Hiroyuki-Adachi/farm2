require "test_helper"

class Tablets::MapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "タブレット版の地図に他組織の土地を表示しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")

    get tablets_maps_path

    assert_response :success
    assert_select "input#land_#{other_land.id}", count: 0
  end
end
