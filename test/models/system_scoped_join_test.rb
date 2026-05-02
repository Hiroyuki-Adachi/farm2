require 'test_helper'

class SystemScopedJoinTest < ActiveSupport::TestCase
  test "work by_target does not duplicate rows for another organization system" do
    work = works(:works1)
    scope = Work.by_target(2015)

    assert_includes scope.pluck(:id), work.id
    assert_equal scope.distinct.pluck(:id).sort, scope.pluck(:id).sort
    assert_empty scope.where.not(organization_id: work.organization_id).pluck(:id)
  end

  test "work result by_home does not duplicate rows for another organization system" do
    work_result = work_results(:work_results0)
    scope = WorkResult.by_home(2015)

    assert_includes scope.pluck(:id), work_result.id
    assert_equal scope.distinct.pluck(:id).sort, scope.pluck(:id).sort
    assert_empty scope.where.not(work_results: {organization_id: work_result.organization_id}).pluck(:id)
  end

  test "machine result by_home does not duplicate rows for another organization system" do
    machine_result = MachineResult.by_home(2015).first
    scope = MachineResult.by_home(2015)

    assert_includes scope.pluck(:id), machine_result.id
    assert_equal scope.distinct.pluck(:id).sort, scope.pluck(:id).sort
    assert_empty scope.where.not(machine_results: {organization_id: machine_result.organization_id}).pluck(:id)
  end

  test "machine result by_home can be scoped by organization" do
    other_machine_result = machine_results(:machine_result_other_org)
    machine_result = MachineResult.by_home(2015).where.not(machine_results: {id: other_machine_result.id}).first
    ids = [machine_result.id, other_machine_result.id]

    assert_equal [machine_result.id], MachineResult.by_home(2015, organizations(:org)).where(machine_results: {id: ids}).pluck(:id)
  end

  test "work chemical by_term does not duplicate rows for another organization system" do
    work_chemical = work_chemicals(:work_chemical1)
    scope = WorkChemical.by_term(2015)

    assert_includes scope.pluck(:id), work_chemical.id
    assert_equal scope.distinct.pluck(:id).sort, scope.pluck(:id).sort
    assert_empty scope.where.not(work_chemicals: {organization_id: work_chemical.organization_id}).pluck(:id)
  end

  test "work chemical by_term can be scoped by organization" do
    work_chemical = work_chemicals(:work_chemical1)
    other_work_chemical = work_chemicals(:work_chemical_other_org)
    ids = [work_chemical.id, other_work_chemical.id]

    assert_equal [work_chemical.id], WorkChemical.by_term(2015, organizations(:org)).where(work_chemicals: {id: ids}).pluck(:id)
  end
end
