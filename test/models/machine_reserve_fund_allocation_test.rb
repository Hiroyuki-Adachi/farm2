require "test_helper"

class MachineReserveFundAllocationTest < ActiveSupport::TestCase
  setup do
    @system = systems(:s2015)
    @fund = MachineReserveFund.create!(organization: organizations(:org), machine: machines(:machines1),
                                       started_on: Date.new(2015, 7, 20), years: 2,
                                       total_amount: 240_000, remaining_amount: 240_000)
    @types = [work_types(:work_types1), work_types(:work_types2)]
    @types.each { |type| WorkTypeTerm.find_or_create_by!(work_type: type, term: 2015) }
  end

  test "開始月の日付を無視し初年度と最終年を月割する" do
    assert_equal 6, @fund.months_for(@system)
    assert_equal 60_000, @fund.amount_for(@system)
    assert_equal 12, @fund.months_for(systems(:s2016))
    assert_equal 120_000, @fund.amount_for(systems(:s2016))
    assert_equal 6, @fund.months_for(systems(:s2017))
    assert_equal 60_000, @fund.amount_for(systems(:s2017))
    assert_equal 0, @fund.amount_for(systems(:s2014))
    @fund.started_on = Date.new(2010, 1, 1)
    assert_equal 0, @fund.months_for(@system)
    assert_equal 0, @fund.amount_for(@system)
  end

  test "月割額の端数はDecimalで四捨五入する" do
    @fund.update!(started_on: Date.new(2015, 12, 1), years: 1, total_amount: 7, remaining_amount: 7)
    @fund.reload
    assert_equal 1, @fund.months_for(@system)
    assert_equal 1, @fund.amount_for(@system)
    @fund.total_amount = 6
    assert_equal 1, @fund.amount_for(@system)
    @fund.total_amount = 5
    assert_equal 0, @fund.amount_for(@system)
  end

  test "4月開始の年度境界と残額上限を使用する" do
    @system.assign_attributes(start_date: Date.new(2015, 4, 1), end_date: Date.new(2016, 3, 31))
    assert_equal 9, @fund.months_for(@system)
    @fund.remaining_amount = 12_345
    assert_equal 12_345, @fund.amount_for(@system)
  end

  test "実際の土地履歴を日毎に積算し対象分類全体へ按分する" do
    LandCost.delete_all
    land = lands(:lands0)
    land.update!(area: 10, start_on: @system.start_date, end_on: @system.end_date)
    LandCost.create!(land: land, work_type: @types.first, activated_on: @system.start_date)
    LandCost.create!(land: land, work_type: @types.last, activated_on: Date.new(2015, 7, 1))
    # 他組織の面積は算入しない。
    other_land = land.dup
    other_land.assign_attributes(organization: organizations(:org2), owner_id: nil, manager_id: nil,
                                 uuid: SecureRandom.uuid, place: "他組織", area: 99)
    other_land.save!
    LandCost.create!(land: other_land, work_type: @types.first, activated_on: @system.start_date)
    detail = @fund.build_detail(@system)
    detail.amount = 36_500
    assert detail.register(@system), detail.errors.full_messages.join
    costs = detail.machine_reserve_fund_costs
    assert_equal WorkType.land.by_term(2015).count, costs.count
    assert_equal 18_100, costs.find_by!(work_type: @types.first).cost
    assert_equal 18_400, costs.find_by!(work_type: @types.last).cost
    assert_equal 36_500, costs.sum(:cost)
    assert_equal 203_500, @fund.reload.current_remaining_amount
    assert_equal 203_500, detail.reload.remaining_amount
  end

  test "年度面積の集計クエリ数は作業分類数によらず日数と一致する" do
    detail = @fund.build_detail(@system)
    queries = []
    subscriber = lambda do |_name, _started, _finished, _id, payload|
      queries << payload[:sql] if payload[:sql].match?(/SELECT.*SUM.*FROM "land_costs"/i)
    end
    ActiveRecord::Base.uncached do
      ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
        assert detail.register(@system), detail.errors.full_messages.join
      end
    end
    assert_equal (@system.start_date..@system.end_date).count, queries.size
  end

  test "丸め誤差を最大原価行へ寄せる" do
    LandCost.stubs(:sum_areas_by_work_type).returns(@types.to_h { |type| [type.id, 1.to_d] })
    detail = @fund.build_detail(@system)
    detail.amount = 101
    assert detail.register(@system)
    assert_equal [50, 51], detail.machine_reserve_fund_costs.where(work_type: @types).pluck(:cost).sort
    assert_equal 101, detail.machine_reserve_fund_costs.sum(:cost)
  end

  test "面積0の場合は明細も原価も作らない" do
    LandCost.stubs(:sum_areas_by_work_type).returns({})
    detail = @fund.build_detail(@system)
    assert_no_difference ["MachineReserveFundDetail.count", "MachineReserveFundCost.count"] do
      assert_not detail.register(@system)
    end
    assert_includes detail.errors.full_messages.join, "圃場面積が0"
  end

  test "期間外、残額超過、負額、未入力を拒否する" do
    [240_001, -1, nil].each do |amount|
      detail = @fund.build_detail(@system)
      detail.amount = amount
      assert_not detail.register(@system)
    end
    detail = @fund.build_detail(systems(:s2014))
    assert_not detail.register(systems(:s2014))
  end

  test "同年度の二重登録を拒否し削除で原価と残額を戻す" do
    LandCost.stubs(:sum_areas_by_work_type).returns(WorkType.land.by_term(2015).to_h { |type| [type.id, 1.to_d] })
    detail = @fund.build_detail(@system)
    assert detail.register(@system)
    duplicate = @fund.build_detail(@system)
    assert_not duplicate.register(@system)
    assert_includes duplicate.errors.attribute_names, :term
    detail.destroy_with_balance!
    assert_not MachineReserveFundCost.exists?(machine_reserve_fund_detail_id: detail.id)
    assert_equal 240_000, @fund.reload.current_remaining_amount
  end
  test "年度を遡って登録や削除しても後続明細の残額を再計算する" do
    LandCost.stubs(:sum_areas_by_work_type).returns(WorkType.land.by_term(2015).to_h { |type| [type.id, 1.to_d] })
    @types.each { |type| WorkTypeTerm.find_or_create_by!(work_type: type, term: 2016) }
    later = @fund.build_detail(systems(:s2016))
    assert later.register(systems(:s2016))
    first = @fund.build_detail(@system)
    assert first.register(@system)
    assert_equal 180_000, first.reload.remaining_amount
    assert_equal 60_000, later.reload.remaining_amount
    first.destroy_with_balance!
    assert_equal 120_000, later.reload.remaining_amount
  end

  test "異なる組織や年度のSystemでは登録しない" do
    detail = @fund.build_detail(@system)
    assert_not detail.register(systems(:s2015_org2))
    assert_not detail.register(systems(:s2016))
  end

  test "対象作業分類がない年度では登録しない" do
    WorkTypeTerm.where(term: 2015).delete_all
    detail = @fund.build_detail(@system)
    assert_not detail.register(@system)
    assert_includes detail.errors.full_messages.join, "圃場面積が0"
  end

  test "少額を多数の分類に丸めても端数は最大行へ寄せて合計を一致させる" do
    WorkTypeTerm.where(term: 2015).delete_all
    6.times do |index|
      type = @types.first.dup
      type.name = "按分#{index}"
      type.save!
      WorkTypeTerm.create!(work_type: type, term: 2015)
    end
    LandCost.stubs(:sum_areas_by_work_type).returns(WorkType.land.by_term(2015).to_h { |type| [type.id, 1.to_d] })
    detail = @fund.build_detail(@system)
    detail.amount = 3
    assert detail.register(@system), detail.errors.full_messages.join
    assert_equal [-2, 1, 1, 1, 1, 1], detail.machine_reserve_fund_costs.pluck(:cost).sort
    assert_equal 3, detail.machine_reserve_fund_costs.sum(:cost)
  end
end
