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
#

require 'test_helper'

class FixTest < ActiveSupport::TestCase
  setup do
    @fixed_at = Date.new(2015, 3, 31)
    @term = 2015
    @worker_id = users(:users1).worker_id
    @no_fix_works = [works(:work_no_fix1).id, works(:work_no_fix2).id]
  end
    
  test "確定" do
    assert_difference('Fix.count') do
      Fix.do_fix(@term, @fixed_at, @worker_id, @no_fix_works)
    end
    assert_equal @fixed_at, Work.find(works(:work_no_fix1).id).fixed_at
    assert_equal @fixed_at, Work.find(works(:work_no_fix2).id).fixed_at

    # 確定データの確認
    created_fix = Fix.find_by(fixed_at: @fixed_at)
    assert_not_nil created_fix
    assert_equal @worker_id, created_fix.fixed_by
    assert_equal @term, created_fix.term
    assert_equal @no_fix_works.size, created_fix.works_count
  end
end
