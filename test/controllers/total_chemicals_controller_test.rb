require 'test_helper'

class TotalChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "薬剤集計" do
    get total_chemicals_path
    assert_response :success
  end
end
