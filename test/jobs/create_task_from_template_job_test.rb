require "test_helper"

class CreateTaskFromTemplateJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test "ジョブによってタスクが生成される" do
    # 2025-02-08 が第2土曜 → 1か月前の 2025-01-08 が生成基準日
    target_template = task_templates(:template1)
    worker_count = Worker.where(office_role: target_template.office_role).count

    travel_to Date.new(2025, 1, 8) do
      assert_difference("TaskWatcher.count", worker_count) do
        assert_difference("Task.count", +1) do
          perform_enqueued_jobs do
            CreateTaskFromTemplateJob.perform_later
          end
        end
      end

      task = Task.last
      assert_equal Date.new(2025, 2, 8), task.due_on
      assert_match target_template.title, task.title
      assert_equal target_template.description, task.description

      target_worker = Worker.find_by(office_role: target_template.office_role)
      assert TaskWatcher.exists?(worker: target_worker, task: task)
    end
  end

  test "ジョブが今日が候補日でない場合にタスクを生成しない" do
    travel_to Date.new(2025, 1, 7) do # 1日前
      assert_no_difference("TaskWatcher.count") do
        assert_no_difference("Task.count") do
          perform_enqueued_jobs do
            CreateTaskFromTemplateJob.perform_later
          end
        end
      end
    end
  end
end
