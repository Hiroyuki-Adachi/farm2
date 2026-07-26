require "test_helper"

class Tasks::Gantts::RowComponentTest < ViewComponent::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "renders one cell per date with task-id and date attributes" do
    task = tasks(:open_task)
    task.update!(planned_start_on: Date.new(2025, 1, 5), due_on: Date.new(2025, 1, 10))
    task = task.decorate(context: { current_worker: @worker })
    dates = (Date.new(2025, 1, 1)..Date.new(2025, 1, 15)).to_a

    render_inline(Tasks::Gantts::RowComponent.new(task: task, dates: dates))

    assert_selector("td[data-task-id='#{task.id}']", count: dates.size)
    assert_selector("td[data-date='2025-01-05']")
  end

  test "marks in-range dates as bar cells with start/end edges" do
    task = tasks(:open_task)
    task.update!(planned_start_on: Date.new(2025, 1, 5), due_on: Date.new(2025, 1, 10))
    task = task.decorate(context: { current_worker: @worker })
    dates = (Date.new(2025, 1, 1)..Date.new(2025, 1, 15)).to_a

    render_inline(Tasks::Gantts::RowComponent.new(task: task, dates: dates))

    assert_selector("td.gantt-cell--bar.gantt-cell--start[data-date='2025-01-05']")
    assert_selector("td.gantt-cell--bar.gantt-cell--end[data-date='2025-01-10']")
    assert_selector("td.gantt-cell--bar[data-date='2025-01-07']")
    assert_no_selector("td.gantt-cell--bar[data-date='2025-01-01']")
  end

  test "renders resize handles only on open task edges" do
    task = tasks(:open_task)
    task.update!(planned_start_on: Date.new(2025, 1, 5), due_on: Date.new(2025, 1, 10))
    task = task.decorate(context: { current_worker: @worker })
    dates = (Date.new(2025, 1, 1)..Date.new(2025, 1, 15)).to_a

    render_inline(Tasks::Gantts::RowComponent.new(task: task, dates: dates))

    assert_selector(".gantt-handle--start[data-task-id='#{task.id}'][data-date='2025-01-05']")
    assert_selector(".gantt-handle--end[data-task-id='#{task.id}'][data-date='2025-01-10']")
  end

  test "closed task uses closed cell classes and has no resize handles" do
    task = tasks(:closed_task)
    task.update!(planned_start_on: Date.new(2025, 1, 5), due_on: nil,
                 started_on: Date.new(2025, 1, 5), ended_on: Date.new(2025, 1, 10))
    task = task.decorate(context: { current_worker: @worker })
    dates = (Date.new(2025, 1, 1)..Date.new(2025, 1, 15)).to_a

    render_inline(Tasks::Gantts::RowComponent.new(task: task, dates: dates))

    assert_selector("td.gantt-cell--bar-closed[data-date='2025-01-07']")
    assert_no_selector(".gantt-handle")
  end
end
