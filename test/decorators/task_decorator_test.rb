# test/decorators/task_decorator_test.rb
require "test_helper"

class TaskDecoratorTest < ActiveSupport::TestCase
  def setup
    @template = task_templates(:template1)
    @task = tasks(:task_template)
    @creator = @task.creator
    @assignee = @task.assignee
    @decorator = TaskDecorator.new(@task)
  end

  test "priority_badge returns HTML" do
    assert_match(/badge/, @decorator.priority_badge)
  end

  test "new_badge returns '新規' when created recently" do
    assert_match(/新規/, @decorator.new_badge)
  end

  test "status_badge returns HTML" do
    assert_match(/badge/, @decorator.status_badge)
  end

  test "creator_name returns creator name" do
    assert_equal @creator.name, @decorator.creator_name
  end

  test "assignee_name returns assignee name" do
    assert_equal @assignee.name, @decorator.assignee_name
  end

  test "kind_badge returns HTML for monthly" do
    assert_match(/badge/, @decorator.kind_badge)
  end

  test "due_on_display formats date" do
    assert_match(/\d{4}/, @decorator.due_on_display)
  end

  # フィクスチャの due_on はロード時の Date.current で決まるため、
  # 実行中に日付をまたいでも結果が変わらないよう、その日の正午に固定する
  test "due_status returns :today for today" do
    travel_to @task.due_on.in_time_zone.change(hour: 12) do
      assert_equal :today, @decorator.due_status
    end
  end

  test "due_badge returns HTML when today" do
    travel_to @task.due_on.in_time_zone.change(hour: 12) do
      assert_match(/badge/, @decorator.due_badge)
      assert_match(/今日/, @decorator.due_badge)
    end
  end
end
