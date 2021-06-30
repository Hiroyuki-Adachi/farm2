require "test_helper"

class Lands::FeesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @home_id = 5
  end

  test "土地原価一覧" do
    get :index
    assert_response :success
  end

  test "土地原価一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "土地原価変更(表示)" do
    get :edit, params: {id: @home_id}
    assert_response :success
  end

  test "土地原価変更(実行)" do
    land_genka2 = lands(:land_genka2)
    update = {
      land_genka2.id => {
        manage_fee: 30000,
        peasant_fee: 40000,
        term: 2015,
        id: nil,
        land_id: land_genka2.id
      }
    }
    assert_difference('LandFee.count', 1) do
      patch :update, params: {id: @home_id, land_fees: update}
    end
    assert_redirected_to lands_fees_path
  end
end
