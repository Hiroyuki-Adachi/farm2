# == Schema Information
#
# Table name: fixes(確定データ)
#
#  fixed_at(確定日)                :date             not null, primary key
#  fixed_by(確定者)                :integer
#  hours(合計作業工数)             :integer          not null
#  machines_amount(合計機械利用料) :decimal(8, )     not null
#  term(年度(期))                  :integer          default(0), not null, primary key
#  works_amount(合計作業日当)      :decimal(8, )     not null
#  works_count(合計作業数)         :integer          not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  organization_id(組織)           :bigint           default(3), not null, primary key
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

require 'test_helper'

class FixTest < ActiveSupport::TestCase
  setup do
    @fixed_at = Date.new(2015, 3, 31)
    @term = 2015
    @organization = organizations(:org)
    @worker_id = users(:users1).worker_id
    @no_fix_works = [works(:work_no_fix1).id, works(:work_no_fix2).id]
  end

  test "確定日当は対象組織の既定単価を保存する" do
    organization = organizations(:org2)
    systems(:s2015_org2).update!(default_price: 2300)
    work = works(:work_for_price)
    work.update!(organization_id: organization.id, term: @term,
                 work_kind_id: work_kinds(:work_kind_first_term).id, fixed_at: nil)
    assert_predicate work.work_results, :any?

    Fix.do_fix(organization, @term, @fixed_at, @worker_id, [work.id])

    work.work_results.reload.each do |result|
      assert_equal 2300, result.fixed_price
      assert_equal result.hours * 2300, result.fixed_amount
    end
  end

  test "期首当日と期末当日は確定でき取消で元に戻る" do
    [Date.new(2015, 1, 1), Date.new(2015, 12, 31)].each do |date|
      fix = Fix.do_fix(@organization, @term, date, @worker_id, @no_fix_works)
      assert_equal date, works(:work_no_fix1).reload.fixed_at
      fix.destroy!
      assert_nil works(:work_no_fix1).reload.fixed_at
      assert_nil works(:work_no_fix2).reload.fixed_at
      works(:work_no_fix1).work_results.each { |result| assert_nil result.fixed_amount }
    end
  end

  test "期首前と期末翌日は書き込まず拒否する" do
    [Date.new(2014, 12, 31), Date.new(2016, 1, 1)].each do |date|
      assert_no_difference('Fix.count') do
        assert_raises(Fix::InvalidInput) { Fix.do_fix(@organization, @term, date, @worker_id, @no_fix_works) }
      end
      assert_nil works(:work_no_fix1).reload.fixed_at
    end
  end

  test "別期と別組織と存在しない作業が混在した場合は全件書き込まず拒否する" do
    other = works(:work_no_fix2)
    [{ term: 2014 }, { term: 2015, organization_id: organizations(:org2).id }].each do |attributes|
      other.update!(attributes)
      assert_no_difference('Fix.count') do
        assert_raises(Fix::InvalidInput) { Fix.do_fix(@organization, @term, @fixed_at, @worker_id, @no_fix_works) }
      end
      assert_nil works(:work_no_fix1).reload.fixed_at
      assert_nil other.reload.fixed_at
    end
    assert_raises(Fix::InvalidInput) do
      Fix.do_fix(@organization, @term, @fixed_at, @worker_id, [@no_fix_works.first, -1])
    end
  end

  test "作業未選択は確定データを作らず拒否する" do
    [nil, []].each do |ids|
      assert_no_difference('Fix.count') do
        assert_raises(Fix::InvalidInput) { Fix.do_fix(@organization, @term, @fixed_at, @worker_id, ids) }
      end
    end
  end

  test "ジョブも期外の日付を拒否する" do
    assert_no_difference('Fix.count') do
      assert_raises(Fix::InvalidInput) do
        FixWorksJob.perform_now(@organization.id, @term, '2016-01-01', @worker_id, @no_fix_works)
      end
    end
    assert_nil works(:work_no_fix1).reload.fixed_at
  end

  test "確定" do
    assert_difference('Fix.count') do
      Fix.do_fix(@organization, @term, @fixed_at, @worker_id, @no_fix_works)
    end
    assert_equal @fixed_at, Work.find(works(:work_no_fix1).id).fixed_at
    assert_equal @fixed_at, Work.find(works(:work_no_fix2).id).fixed_at

    # 確定データの確認
    created_fix = Fix.find_by(organization: @organization, fixed_at: @fixed_at)
    assert_not_nil created_fix
    assert_equal @worker_id, created_fix.fixed_by
    assert_equal @term, created_fix.term
    assert_equal @no_fix_works.size, created_fix.works_count
  end
end
