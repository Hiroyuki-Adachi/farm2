require "test_helper"

class WorkDetailOrganizationScopeTest < ActiveSupport::TestCase
  test "作業詳細を親作業の組織で絞り込む" do
    work_details.each { |record| assert_organization_scope(record) }
    assert_work_work_type_scope
  end

  private

  def work_details
    [
      WorkLand.create!(work: other_work, land: lands(:lands0), work_type: work_type),
      WorkChemical.create!(work: other_work, chemical: chemical, quantity: 1, chemical_group_no: 2),
      create_work_broccoli,
      WorkWholeCrop.create!(work: other_work),
      WorkVerification.create!(work: other_work, worker: workers(:worker_other_org)),
      work_results(:work_result_other_org)
    ]
  end

  def create_work_broccoli
    now = Time.current
    # rubocop:disable Rails/SkipsModelValidations
    WorkBroccoli.insert_all!([{ work_id: other_work.id, shipped_on: Date.current, created_at: now, updated_at: now }])
    # rubocop:enable Rails/SkipsModelValidations
    WorkBroccoli.find_by!(work: other_work)
  end

  def assert_organization_scope(record)
    assert record.class.for_organization(organizations(:org2)).exists?(record.id), record.class.name
    assert_not record.class.for_organization(organizations(:org)).exists?(record.id), record.class.name
  end

  def assert_work_work_type_scope
    record = WorkWorkType.create!(work: other_work, work_type: work_type)
    conditions = { work_id: record.work_id, work_type_id: record.work_type_id }

    assert WorkWorkType.for_organization(organizations(:org2)).exists?(conditions)
    assert_not WorkWorkType.for_organization(organizations(:org)).exists?(conditions)
  end

  def other_work
    works(:work_other_org)
  end

  def work_type
    work_types(:work_types1)
  end

  def chemical
    work_chemicals(:work_chemical_other_org).chemical
  end
end
