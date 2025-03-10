require "test_helper"

class Chemicals::AnnualsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "薬剤年次更新(最新年度以外)" do
    post chemicals_annuals_path
    assert_response :error
  end

  test "薬剤年次更新(管理者以外)" do
    login_as(users(:user2017c))
    post chemicals_annuals_path
    assert_response :error
  end

  test "薬剤年次更新" do
    user = users(:user2017)
    login_as(user)
    system = System.find_by(term: user.term, organization_id: user.organization_id)
    travel_to system.start_date do
      assert_difference('ChemicalTerm.count', ChemicalTerm.where(term: 2016).count) do
        post chemicals_annuals_path
      end
      assert_redirected_to chemicals_path
    end
  end
end
