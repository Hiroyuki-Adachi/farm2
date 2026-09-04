require "test_helper"

class StatisticsMachineQueryTest < ActiveSupport::TestCase
  test "年度別機械稼働時間一覧クエリ" do
    organization = organizations(:org)
    systems, machines, hours = StatisticsMachineQuery.new(organization).call

    assert_equal [2014, 2015, 2016, 2017], systems.map(&:term)

    machine_result = machine_results(:machine_results1)
    work = machine_result.work_result.work

    assert machine_result.machine.owner.company_flag?

    expected_hours = MachineResult
      .joins(work_result: :work)
      .where(machine_id: machine_result.machine_id, works: { term: work.term, organization_id: organization.id })
      .sum(:hours)

    assert_includes machines.map(&:id), machine_result.machine.id
    assert_equal expected_hours, hours[[work.term, machine_result.machine_id]]
  end

  test "組合所有(company_flag: true)以外の機械は一覧に含まれない" do
    organization = organizations(:org)
    _systems, machines, _hours = StatisticsMachineQuery.new(organization).call

    non_company_machine = machine_results(:machine_result_for_price1).machine

    assert_not non_company_machine.owner.company_flag?
    assert_not_includes machines.map(&:id), non_company_machine.id
  end
end
