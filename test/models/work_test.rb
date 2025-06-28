# == Schema Information
#
# Table name: works(作業データ)
#
#  id(作業データ)                          :integer          not null, primary key
#  chemical_group_flag(薬剤グループフラグ) :boolean          default(FALSE), not null
#  created_by(作成者)                      :integer
#  end_at(終了時刻)                        :time             not null
#  fixed_at(確定日)                        :date
#  name(作業名称)                          :string(40)       not null
#  printed_at(印刷日時)                    :datetime
#  printed_by(印刷者)                      :integer
#  remarks(備考)                           :text
#  start_at(開始時刻)                      :time             not null
#  term(年度(期))                          :integer          not null
#  worked_at(作業日)                       :date             not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  weather_id(天気)                        :integer
#  work_kind_id(作業種別)                  :integer          default(0), not null
#  work_type_id(作業分類)                  :integer
#

require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_for_price)
    @sum_hours = work_results(:work_result_for_price1).hours + work_results(:work_result_for_price2).hours
    @sum_areas = lands(:lands0).area + lands(:lands1).area
  end

  test "作業者数" do
    assert_equal 2, @work.workers_count
  end

  test "作業時間" do
    assert_equal @sum_hours, @work.sum_hours
  end

  test "作業面積" do
    assert_equal @sum_areas, @work.sum_areas
  end

  test "作業単価" do
    assert_equal @work.term, @work.price
  end

  test "作業金額合計" do
    assert_equal @work.term * @sum_hours, @work.sum_workers_amount
  end

  test "工数統計_総合計" do
    total_hours = Work.joins(:work_results).where(term: 2015).sum("work_results.hours")
    assert_equal total_hours, Work.total_all[2015]
  end

  test "工数統計_ジャンル別" do
    total_hours = Work.joins(:work_results)
        .joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
        .where(term: 2015, "work_types.genre" => 1).sum("work_results.hours")
    assert_equal total_hours, Work.total_genre[[1, 2015]]
  end

  test "作業種別キャッシュ" do
    w = works(:work_for_work_type_cache)
    w.regist_work_work_types
    wts = w.work_types.order(id: :asc)
    assert_equal wts.count, 2
    assert wts.ids.include?(land_costs(:land_cost_genka1).work_type_id)
    assert wts.ids.include?(land_costs(:land_cost_genka21).work_type_id)
  end

  test "作業者登録" do
    old_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker1).id)
    params = ActionController::Parameters.new(
      {
        results: 
          [
            {worker_id: workers(:worker1).id, hours: 1.5, display_order: 1},
            {worker_id: workers(:worker4).id, hours: 4.5, display_order: 2}
          ]
      }
    )
    @work.regist_results(params[:results], workers(:worker3))
    assert_equal params[:results].size, @work.work_results.count

    # 更新データの確認
    updated_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker1).id)
    assert_not_equal old_result.updated_at, updated_result.updated_at
    assert_equal 1.5, updated_result.hours
    assert_equal 1, updated_result.display_order

    # 作成データの確認
    created_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker4).id)
    assert_not_nil created_result
    assert_equal 4.5, created_result.hours
    assert_equal 2, created_result.display_order

    # 削除データの確認
    deleted_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker2).id)
    assert_nil deleted_result

    # 印刷情報のクリア確認
    assert_nil @work.printed_at
    assert_nil @work.printed_by
  end

  test "農地登録" do
    old_work_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands0).id)
    params = ActionController::Parameters.new(
      {
        work_lands: 
          [
            {land_id: lands(:lands0).id, display_order: 1},
            {land_id: lands(:lands3).id, display_order: 2}
          ]
      }
    )

    @work.regist_lands(params[:work_lands])
    assert_equal params[:work_lands].size, @work.work_lands.count

    # 更新データの確認
    updated_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands0).id)
    assert_equal old_work_land.updated_at, updated_land.updated_at

    # 作成データの確認
    created_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands3).id)
    assert_not_nil created_land
    assert_equal 2, created_land.display_order

    # 削除データの確認
    deleted_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands1).id)
    assert_nil deleted_land
  end

  test "機械登録" do
    params = ActionController::Parameters.new(
      {
        machine_hours: 
          {
            machines(:machine_hour_t).id.to_s => {work_results(:work_result_for_price1).id.to_s => 2.5},
            machines(:machine_area_t).id.to_s => {work_results(:work_result_for_price2).id.to_s => 3.0},
            machines(:machine_day_t).id.to_s => {work_results(:work_result_for_price2).id.to_s => 0}
          }
      }
    )

    @work.regist_machines(params[:machine_hours])
    assert_equal 2, @work.machine_results.count

    # 更新データの確認
    updated_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price1).id, machine_id: machines(:machine_hour_t).id)
    assert_equal 2.5, updated_machine.hours

    # 作成データの確認
    created_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price2).id, machine_id: machines(:machine_area_t).id)
    assert_not_nil created_machine
    assert_equal 3.0, created_machine.hours

    # 削除データの確認
    deleted_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price2).id, machine_id: machines(:machine_day_t).id)
    assert_nil deleted_machine
  end
end
