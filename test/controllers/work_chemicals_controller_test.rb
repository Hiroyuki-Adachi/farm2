require 'test_helper'

class WorkChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "作業別薬剤使用料一覧" do
    get work_chemicals_path
    assert_response :success
  end
end
