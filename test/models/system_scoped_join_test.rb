require 'test_helper'

class SystemScopedJoinTest < ActiveSupport::TestCase
  test "work by_target does not duplicate rows for another organization system" do
    work = works(:works1)

    assert_equal [work.id], Work.by_target(2015).where(id: work.id).pluck(:id)
  end

  test "work result by_home does not duplicate rows for another organization system" do
    work_result = work_results(:work_results0)

    assert_equal [work_result.id], WorkResult.by_home(2015).where(work_results: { id: work_result.id }).pluck(:id)
  end

  test "machine result by_home does not duplicate rows for another organization system" do
    machine_result = MachineResult.by_home(2015).first

    assert_equal [machine_result.id], MachineResult.by_home(2015).where(machine_results: { id: machine_result.id }).pluck(:id)
  end

  test "machine result by_home can be scoped by organization" do
    other_machine_result = machine_results(:machine_result_other_org)
    machine_result = MachineResult.by_home(2015).where.not(machine_results: { id: other_machine_result.id }).first
    ids = [machine_result.id, other_machine_result.id]

    assert_equal [machine_result.id], MachineResult.by_home(2015, organizations(:org)).where(machine_results: { id: ids }).pluck(:id)
  end

  test "work chemical by_term does not duplicate rows for another organization system" do
    work_chemical = work_chemicals(:work_chemical1)

    assert_equal [work_chemical.id], WorkChemical.by_term(2015).where(work_chemicals: { id: work_chemical.id }).pluck(:id)
  end

  test "work chemical by_term can be scoped by organization" do
    work_chemical = work_chemicals(:work_chemical1)
    other_work_chemical = work_chemicals(:work_chemical_other_org)
    ids = [work_chemical.id, other_work_chemical.id]

    assert_equal [work_chemical.id], WorkChemical.by_term(2015, organizations(:org)).where(work_chemicals: { id: ids }).pluck(:id)
  end
end
