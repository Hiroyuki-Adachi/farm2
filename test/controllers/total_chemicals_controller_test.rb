require 'test_helper'

class TotalChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @system = systems(:s2015)
  end

  test "薬剤集計" do
    get :index
    assert_response :success
  end
end
