require 'test_helper'

class DepreciationsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "減価償却一覧" do
    get :index
    assert_response :success
  end

  test "減価償却一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "減価償却作成(実行)" do
    update = {
      cost: 500,
      machine_id: machines(:machines1).id,
      work_types: [work_types(:work_type_koshi).id, work_types(:work_types1).id],
      term: 2015
    }
    assert_difference('DepreciationType.count', 2) do
      post :create, params: {depreciations: [update]}
    end
    assert_redirected_to depreciations_path

    updated = Depreciation.find_by(term: update[:term], machine_id: machines(:machines1).id)
    assert_equal update[:cost], updated.cost
  end
end
