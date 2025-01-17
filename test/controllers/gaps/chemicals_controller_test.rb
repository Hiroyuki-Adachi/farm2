require "test_helper"

class Gaps::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP農薬台帳(一覧)" do
    get gaps_chemicals_path
    assert_response :success
  end
end
