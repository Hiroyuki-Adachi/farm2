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
