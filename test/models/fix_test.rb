# == Schema Information
#
# Table name: fixes
#
#  term            :integer          default("0"), not null, primary key
#  fixed_at        :date             not null, primary key
#  works_count     :integer          not null
#  hours           :integer          not null
#  works_amount    :decimal(8, )     not null
#  machines_amount :decimal(8, )     not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  fixed_by        :integer
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
    assert_equal @worker_id, Fix.where(fixed_at: @fixed_at, term: @term).first.fixed_by
  end
end
