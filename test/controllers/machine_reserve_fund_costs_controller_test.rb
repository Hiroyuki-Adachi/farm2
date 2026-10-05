require "test_helper"

class MachineReserveFundCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @fund = MachineReserveFund.create!(organization: organizations(:org), machine: machines(:machines1),
                                       started_on: Date.new(2015, 1, 1), years: 2,
                                       total_amount: 240_000, remaining_amount: 240_000)
    @types = [work_types(:work_types1), work_types(:work_types2)]
    @types.each { |type| WorkTypeTerm.find_or_create_by!(work_type: type, term: 2015) }
    LandCost.stubs(:sum_period_areas_by_work_type).returns(@types.to_h { |type| [type.id, 1.to_d] })
    @detail = @fund.build_detail(systems(:s2015))
    @detail.amount = 101
    assert @detail.register(systems(:s2015))
    @values = WorkType.land.by_term(2015).to_h { |type| [type.id.to_s, "0"] }
    @values[@types.first.id.to_s] = "101"
  end

  test "当期明細の原価を編集して一覧へ戻る" do
    get edit_machine_reserve_fund_cost_path(@detail)
    assert_response :success
    assert_select "input[name=?]", "costs[#{@types.first.id}]"
    patch machine_reserve_fund_cost_path(@detail), params: { costs: @values, amount: 0, organization_id: 2 }
    assert_redirected_to machine_reserve_fund_costs_path
    assert_equal 101, @detail.machine_reserve_fund_costs.find_by!(work_type: @types.first).cost
    assert_equal 101, @detail.reload.amount
    get machine_reserve_fund_costs_path
    assert_response :success
    assert_select "tfoot td", text: "101", count: 2
  end

  test "合計不一致は入力値を再表示して保存しない" do
    @values[@types.first.id.to_s] = "100"
    before = @detail.machine_reserve_fund_costs.pluck(:cost)
    patch machine_reserve_fund_cost_path(@detail), params: { costs: @values }
    assert_response :unprocessable_content
    assert_select "input[name=?][value='100']", "costs[#{@types.first.id}]"
    assert_equal before, @detail.machine_reserve_fund_costs.reload.pluck(:cost)
  end

  test "再按分はPOSTで更新し失敗時は原価を保持する" do
    assert @detail.update_costs(@values)
    post reallocate_machine_reserve_fund_cost_path(@detail)
    assert_redirected_to edit_machine_reserve_fund_cost_path(@detail)
    assert_equal [50, 51], @detail.machine_reserve_fund_costs.where(work_type: @types).pluck(:cost).sort
    LandCost.stubs(:sum_period_areas_by_work_type).returns({})
    post reallocate_machine_reserve_fund_cost_path(@detail)
    assert_response :unprocessable_content
    assert_equal 101, @detail.machine_reserve_fund_costs.sum(:cost)
  end

  test "他組織と他年度の編集更新再按分は拒否し一覧にも表示しない" do
    home = Home.create!(organization: organizations(:org2), name: "別組合", phonetic: "べつくみあい", company_flag: true,
                        display_order: 1)
    machines(:machine_other_org).update!(home_id: home.id)
    other_fund = MachineReserveFund.create!(organization: organizations(:org2), machine: machines(:machine_other_org),
                                            started_on: Date.new(2015, 1, 1), years: 1,
                                            total_amount: 120_000, remaining_amount: 120_000)
    other = other_fund.build_detail(systems(:s2015_org2))
    other.save!
    past = @fund.machine_reserve_fund_details.create!(organization: organizations(:org), term: 2014,
                                                      months: 12, amount: 10, remaining_amount: 239_990)
    [other, past].each do |detail|
      get edit_machine_reserve_fund_cost_path(detail)
      assert_response :not_found
      patch machine_reserve_fund_cost_path(detail), params: { costs: @values }
      assert_response :not_found
      post reallocate_machine_reserve_fund_cost_path(detail)
      assert_response :not_found
    end
    get machine_reserve_fund_costs_path
    assert_select "tbody tr", count: 1
    assert_select "tbody td", text: other_fund.machine.alias_name, count: 0
  end

  test "チェック変更で再按分しJSONに金額と選択状態を返す" do
    post reallocate_machine_reserve_fund_cost_path(@detail),
         params: { selected_work_type_ids: [@types.last.id] }, as: :json
    assert_response :success
    first = response.parsed_body["costs"].find { |cost| cost["work_type_id"] == @types.first.id }
    last = response.parsed_body["costs"].find { |cost| cost["work_type_id"] == @types.last.id }
    assert_equal 0, first["cost"]
    assert_not first["allocation_enabled"]
    assert_equal 101, last["cost"]
    assert last["allocation_enabled"]
    assert_equal 101, @detail.machine_reserve_fund_costs.sum(:cost)
  end

  test "全OFFのJSON要求は失敗し保存済みの原価と選択状態を返す" do
    post reallocate_machine_reserve_fund_cost_path(@detail), params: { selected_work_type_ids: [] }, as: :json
    assert_response :unprocessable_content
    assert_includes response.parsed_body["errors"].join, "1つ以上選択"
    assert(response.parsed_body["costs"].all? { |cost| cost["allocation_enabled"] })
    assert_equal(101, response.parsed_body["costs"].sum { |cost| cost["cost"] })
    assert_equal 101, @detail.machine_reserve_fund_costs.sum(:cost)
  end

  test "管理権限のないユーザーは一覧編集更新再按分にアクセスできない" do
    logout
    login_as(users(:user_user))
    get machine_reserve_fund_costs_path
    assert_response :service_unavailable
    get edit_machine_reserve_fund_cost_path(@detail)
    assert_response :service_unavailable
    patch machine_reserve_fund_cost_path(@detail), params: { costs: @values }
    assert_response :service_unavailable
    post reallocate_machine_reserve_fund_cost_path(@detail)
    assert_response :service_unavailable
    assert_equal [50, 51], @detail.machine_reserve_fund_costs.where(work_type: @types).pluck(:cost).sort
  end
end
