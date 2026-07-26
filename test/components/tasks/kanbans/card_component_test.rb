require "test_helper"

class Tasks::Kanbans::CardComponentTest < ViewComponent::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "renders task title and due badge" do
    task = tasks(:due_on_task).decorate(context: { current_worker: @worker })

    render_inline(Tasks::Kanbans::CardComponent.new(task: task))

    assert_selector("div[data-task-id='#{task.id}']")
    assert_text(task.title)
  end

  test "renders description when present" do
    task = tasks(:due_on_task)
    task.update!(description: "詳細な説明文")
    task = task.decorate(context: { current_worker: @worker })

    render_inline(Tasks::Kanbans::CardComponent.new(task: task))

    assert_text("詳細な説明文")
  end

  test "does not render description paragraph when blank" do
    task = tasks(:open_task).decorate(context: { current_worker: @worker })
    assert task.description.blank?

    render_inline(Tasks::Kanbans::CardComponent.new(task: task))

    assert_no_selector("p")
  end

  test "adds border-danger class when highlighted" do
    task = tasks(:due_on_task)
    task.update!(assignee_id: @worker.id, priority: :urgent)
    task = task.decorate(context: { current_worker: @worker })
    assert task.highlight?

    render_inline(Tasks::Kanbans::CardComponent.new(task: task))

    assert_selector("div.card.border-danger")
  end

  test "does not add border-danger class when not highlighted" do
    task = tasks(:open_task).decorate(context: { current_worker: @worker })
    assert_not task.highlight?

    render_inline(Tasks::Kanbans::CardComponent.new(task: task))

    assert_no_selector("div.card.border-danger")
  end
end
