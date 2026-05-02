require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  test "前期がある場合は期首日が前期期末日の翌日であること" do
    system = systems(:s2015)
    system.start_date = Date.new(2015, 2, 1)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は前期の期末日の翌日にしてください。"
  end

  test "期末日は期首日以降であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2014, 12, 31)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は期首日以降にしてください。"
  end

  test "期首日は月初であること" do
    system = systems(:s2015)
    system.start_date = Date.new(2015, 1, 2)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は月初にしてください。"
  end

  test "期末日は月末であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2015, 12, 30)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は月末にしてください。"
  end

  test "次期がある場合は期末日が次期期首日の前日であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2015, 11, 30)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は次期の期首日の前日にしてください。"
  end

  test "同一組織内で期間が他期と重複しないこと" do
    system = System.new(
      organization_id: organizations(:org).id,
      term: 2018,
      start_date: Date.new(2017, 12, 1),
      end_date: Date.new(2018, 12, 31)
    )

    assert_not_predicate system, :valid?
    assert_includes system.errors[:base], "期首日と期末日が他の期と重複しています。"
  end

  test "term の前後関係と日付の前後関係が逆転しないこと" do
    system = System.new(
      organization_id: organizations(:org).id,
      term: 2018,
      start_date: Date.new(2013, 1, 1),
      end_date: Date.new(2013, 12, 31)
    )

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は前期以前の期間より後にしてください。"
  end

  test "前期がない初年度は前期連続チェックをしない" do
    organization = Organization.create!(name: "初年度テスト", term: 2025)
    system = System.new(
      organization_id: organization.id,
      term: 2025,
      start_date: Date.new(2025, 4, 1),
      end_date: Date.new(2026, 3, 31)
    )

    assert_predicate system, :valid?
  end
end
