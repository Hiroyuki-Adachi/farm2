require "test_helper"

class MachineReserveFundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "他組織の機械へ登録できない" do
    assert_no_difference "MachineReserveFund.count" do
      post machine_reserve_funds_path, params: {
        machine_reserve_fund: {
          machine_id: machines(:machine_other_org).id, started_on: "2025-04-01",
          years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "同組織でも組合所有以外の機械へ登録できない" do
    assert_no_difference "MachineReserveFund.count" do
      post machine_reserve_funds_path, params: {
        machine_reserve_fund: {
          machine_id: machines(:taueki_1).id, started_on: "2025-04-01",
          years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "変更で他組織の機械へ差し替えられない" do
    reserve_fund = MachineReserveFund.create!(
      organization: organizations(:org), machine: machines(:machines1),
      started_on: "2025-04-01", years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
    )

    patch machine_reserve_fund_path(reserve_fund), params: {
      machine_reserve_fund: { machine_id: machines(:machine_other_org).id }
    }

    assert_response :unprocessable_content
    assert_equal machines(:machines1).id, reserve_fund.reload.machine_id
  end
end
