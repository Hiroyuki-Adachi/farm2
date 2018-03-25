require 'test_helper'

class WorkChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "作業別薬剤使用料一覧" do
    get :index
    assert_response :success
  end
end
