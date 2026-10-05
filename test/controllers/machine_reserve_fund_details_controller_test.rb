require "test_helper"

class MachineReserveFundDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @fund = MachineReserveFund.create!(organization: organizations(:org), machine: machines(:machines1),
                                       started_on: Date.new(2015, 1, 1), years: 1,
                                       total_amount: 120_000, remaining_amount: 120_000)
    LandCost.stubs(:sum_period_areas_by_work_type).returns(WorkType.land.by_term(2015).to_h do |type|
      [type.id, 1.to_d]
    end)
  end

  test "登録時は年度と組織をサーバー側で決定する" do
    post machine_reserve_fund_details_path, params: { machine_reserve_fund_id: @fund.id,
                                                      machine_reserve_fund_detail: { amount: 100, term: 2016,
                                                                                     organization_id: 2,
                                                                                     months: 1, remaining_amount: 0 } }
    assert_redirected_to machine_reserve_fund_details_path
    detail = @fund.machine_reserve_fund_details.sole
    assert_equal 2015, detail.term
    assert_equal @fund.organization_id, detail.organization_id
    assert_equal 12, detail.months
    assert_equal 119_900, detail.remaining_amount
    assert_equal 100, detail.machine_reserve_fund_costs.sum(:cost)
  end

  test "他組織の登録画面と登録と削除にアクセスできない" do
    home = Home.create!(organization: organizations(:org2), name: "別組合", phonetic: "べつくみあい", company_flag: true,
                        display_order: 1)
    machines(:machine_other_org).update!(home_id: home.id)
    other = MachineReserveFund.create!(organization: organizations(:org2), machine: machines(:machine_other_org),
                                       started_on: Date.new(2015, 1, 1), years: 1,
                                       total_amount: 120_000, remaining_amount: 120_000)
    get new_machine_reserve_fund_detail_path, params: { machine_reserve_fund_id: other.id }
    assert_response :not_found
    post machine_reserve_fund_details_path,
         params: { machine_reserve_fund_id: other.id, machine_reserve_fund_detail: { amount: 100 } }
    assert_response :not_found
    detail = other.build_detail(systems(:s2015_org2))
    detail.save!
    delete machine_reserve_fund_detail_path(detail)
    assert_response :not_found
    assert MachineReserveFundDetail.exists?(detail.id)
  end

  test "残額超過はエラー画面となり保存されない" do
    assert_no_difference "MachineReserveFundDetail.count" do
      post machine_reserve_fund_details_path,
           params: { machine_reserve_fund_id: @fund.id, machine_reserve_fund_detail: { amount: 120_001 } }
    end
    assert_response :unprocessable_content
  end

  test "当期登録で残額が0になっても確認と削除ができる" do
    detail = @fund.build_detail(systems(:s2015))
    assert detail.register(systems(:s2015))
    get machine_reserve_fund_details_path
    assert_select "td", text: "登録済"
    delete machine_reserve_fund_detail_path(detail)
    assert_redirected_to machine_reserve_fund_details_path
    assert_equal 120_000, @fund.reload.current_remaining_amount
  end
end
