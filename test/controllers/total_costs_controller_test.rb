require 'test_helper'

class TotalCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "原価一覧" do
    get total_costs_path
    assert_response :success
  end

  test "未計算時は最大の締め月を選択する" do
    Fix.create!(fixes(:fix1).attributes.merge("fixed_at" => Date.new(2015, 3, 31)))

    get total_costs_path

    assert_select 'select[name="fixed_on"] option[selected]', count: 1 do
      assert_select '[value="2015-03-31"]'
    end
  end

  test "表示中の原価を計算した締め月を選択する" do
    Fix.create!(fixes(:fix1).attributes.merge("fixed_at" => Date.new(2015, 3, 31)))
    systems(:s2015).update!(total_cost_fixed_on: Date.new(2015, 2, 28))
    systems(:s2017).update!(total_cost_fixed_on: Date.new(2017, 12, 31))
    systems(:s2015_org2).update!(total_cost_fixed_on: Date.new(2015, 3, 31))

    get total_costs_path

    assert_select 'select[name="fixed_on"] option[selected]', count: 1 do
      assert_select '[value="2015-02-28"]'
    end
  end

  test "締め月がない場合も表示できる" do
    Fix.where(organization_id: @user.organization_id, term: @user.term).delete_all

    get total_costs_path

    assert_response :success
    assert_select 'select[name="fixed_on"] option', count: 0
  end

  test "原価を削除したら締め月の記録も消す" do
    systems(:s2015).update!(total_cost_fixed_on: Date.new(2015, 2, 28))

    delete total_cost_path(1)

    assert_redirected_to total_costs_path
    assert_nil systems(:s2015).reload.total_cost_fixed_on
  end

  test "原価一覧(管理者以外)" do
    login_as(users(:user_checker))
    get total_costs_path
    assert_response :error
  end

  test "原価計算" do
    assert_enqueued_with(job: TotalCostsMakeJob) do
      post total_costs_path, params: { fixed_on: "2015-12-31" }
    end
    assert_redirected_to total_costs_path
  end
end
