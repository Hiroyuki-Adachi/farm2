require "test_helper"

class TaskScheduleDetailOrganizationScopeTest < ActiveSupport::TestCase
  test "タスク関連を親タスクの組織で絞り込む" do
    task_records.each { |record| assert_organization_scope(record) }
  end

  test "予定関連を親予定の組織で絞り込む" do
    schedule_records.each { |record| assert_organization_scope(record) }
  end

  test "個人予定に他組織の予定を含めない" do
    schedule = other_schedule
    schedule.update_column(:worked_at, Time.zone.today) # rubocop:disable Rails/SkipsModelValidations
    record = ScheduleWorker.create!(schedule: schedule, worker: workers(:worker1))

    assert_not ScheduleWorker.for_personal(workers(:worker1), 1).exists?(record.id)
  end

  private

  def task_records
    task = other_task
    [
      TaskComment.create!(task: task, poster: other_worker, body: "別組織のコメント"),
      task.events.first,
      task.reads.first,
      task.task_watchers.first
    ]
  end

  def schedule_records
    schedule = other_schedule
    [
      ScheduleSection.create!(schedule: schedule, section: sections(:section_other_org)),
      ScheduleWorker.create!(schedule: schedule, worker: other_worker)
    ]
  end

  def assert_organization_scope(record)
    conditions = Array(record.class.primary_key).zip(Array(record.id)).to_h

    assert record.class.for_organization(organizations(:org2)).where(conditions).exists?, record.class.name
    assert_not record.class.for_organization(organizations(:org)).where(conditions).exists?, record.class.name
  end

  def other_task
    @other_task ||= Task.create!(
      organization: organizations(:org2),
      title: "別組織のタスク",
      creator: other_worker,
      assignee: other_worker
    )
  end

  def other_schedule
    @other_schedule ||= schedules(:schedule1).dup.tap do |schedule|
      schedule.organization = organizations(:org2)
      schedule.created_by = other_worker.id
      schedule.term = 2015
      # rubocop:disable Rails/SkipsModelValidations
      schedule.save!(validate: false)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def other_worker
    workers(:worker_other_org)
  end
end
