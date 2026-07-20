require "test_helper"

class DepreciationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "他組織の機械へ減価償却を移動できない" do
    depreciation = depreciations(:depreciation1)

    assert_no_changes -> { depreciation.reload.attributes.slice("machine_id", "cost") } do
      post depreciations_path, params: {
        depreciations: [{
          id: depreciation.id,
          machine_id: machines(:machine_other_org).id,
          cost: 100,
          term: depreciation.term
        }]
      }
    end

    assert_response :not_found
  end
end
