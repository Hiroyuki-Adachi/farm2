require "test_helper"

class SystemPeriodDataTest < ActiveSupport::TestCase
  setup do
    # 組織2の最新の期（2015-01-01〜2015-12-31）。
    # 組織2には2015-04-01の作業日報1件と、2015年前半のソリマチ仕訳2件がある。
    @system = systems(:s2015_org2)
    @organization_id = @system.organization_id
  end

  test "期末を短縮して作業日報・作業予定・確定が期外になる場合は拒否し件数を表示する" do
    create_work(@organization_id, Date.new(2015, 10, 1))
    create_work(@organization_id, Date.new(2015, 11, 1))
    create_schedule(@organization_id, Date.new(2015, 12, 1))
    create_fix(@organization_id, Date.new(2015, 10, 31))

    assert_not @system.update(end_date: Date.new(2015, 6, 30))
    assert_includes @system.errors[:base],
                    "期間を変更すると期外になるデータがあります（作業日報 2件、作業予定 1件、確定 1件）。"
    assert_equal Date.new(2015, 12, 31), @system.reload.end_date
  end

  test "期首を遅らせて既存データが期外になる場合は拒否する" do
    assert_not @system.update(start_date: Date.new(2015, 6, 1))
    assert_includes @system.errors[:base], "期間を変更すると期外になるデータがあります（作業日報 1件、ソリマチ仕訳 2件）。"
    assert_equal Date.new(2015, 1, 1), @system.reload.start_date
  end

  test "データがない範囲だけ期末を短縮する場合は保存できる" do
    assert @system.update(end_date: Date.new(2015, 6, 30))
  end

  test "期末を延長する場合は保存できる" do
    create_work(@organization_id, Date.new(2015, 10, 1))

    assert @system.update(end_date: Date.new(2016, 3, 31))
  end

  test "既に期外だった作業日報があっても、それ以外に影響がなければ保存できる" do
    create_work(@organization_id, Date.new(2016, 2, 1))

    assert @system.update(end_date: Date.new(2015, 6, 30))
  end

  test "別組織のデータは判定に含めない" do
    create_work(1, Date.new(2015, 10, 1), term: @system.term)
    create_schedule(1, Date.new(2015, 10, 1))
    create_fix(1, Date.new(2015, 10, 31))

    assert @system.update(end_date: Date.new(2015, 6, 30))
  end

  test "期間を変えない更新では既存データを判定しない" do
    create_work(@organization_id, Date.new(2016, 2, 1))

    assert @system.update(dry_price: 1500)
  end

  private

  def create_work(organization_id, worked_at, term: @system.term)
    work = works(:work_other_org).dup
    work.assign_attributes(organization_id: organization_id, term: term, worked_at: worked_at, fixed_at: nil)
    # 期外の作業日報を再現するため、作業日報側の検証を通さない。
    work.save!(validate: false)
    work
  end

  def create_schedule(organization_id, worked_at)
    schedule = schedules(:schedule1).dup
    schedule.assign_attributes(organization_id: organization_id, worked_at: worked_at)
    # 作業予定の作業分類・年度の検証はこのテストの対象外のため通さない。
    schedule.save!(validate: false)
    schedule
  end

  def create_fix(organization_id, fixed_at)
    Fix.create!(organization_id: organization_id, term: @system.term, fixed_at: fixed_at,
                works_count: 0, hours: 0, works_amount: 0, machines_amount: 0)
  end
end
