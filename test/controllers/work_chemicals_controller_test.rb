require 'test_helper'

class WorkChemicalsControllerTest < ActionController::TestCase
  test "作業別薬剤使用料一覧" do
    get :index
    assert_response :success
  end

end
