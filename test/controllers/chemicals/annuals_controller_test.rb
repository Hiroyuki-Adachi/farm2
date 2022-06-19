require "test_helper"

class Chemicals::AnnualsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "薬剤年次更新(最新年度以外)" do
    post :create
    assert_response :error
  end

  test "薬剤年次更新(管理者以外)" do
    session[:user_id] = users(:user2017c).id
    post :create
    assert_response :error
  end

  test "薬剤年次更新" do
    session[:user_id] = users(:user2017).id
    assert_difference('ChemicalTerm.count', ChemicalTerm.where(term: 2016).count) do
      post :create
    end
    assert_redirected_to chemicals_path
  end
end
