require 'test_helper'

class SystemScopedJoinTest < ActiveSupport::TestCase
  test "work by_target does not duplicate rows for another organization system" do
    work = works(:works1)

    assert_equal [work.id], Work.by_target(2015).where(id: work.id).pluck(:id)
  end

  test "work result by_home does not duplicate rows for another organization system" do
    work_result = work_results(:work_results0)

    assert_equal [work_result.id], WorkResult.by_home(2015).where(work_results: {id: work_result.id}).pluck(:id)
  end

  test "machine result by_home does not duplicate rows for another organization system" do
    machine_result = MachineResult.by_home(2015).first

    assert_equal [machine_result.id], MachineResult.by_home(2015).where(machine_results: {id: machine_result.id}).pluck(:id)
  end

  test "work chemical by_term does not duplicate rows for another organization system" do
    work_chemical = work_chemicals(:work_chemical1)

    assert_equal [work_chemical.id], WorkChemical.by_term(2015).where(work_chemicals: {id: work_chemical.id}).pluck(:id)
  end
end
