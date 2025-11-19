class Tasks::KanbansController < ApplicationController
  include PermitChecker

  def show
    @todo_tasks  = Task.kanban_todo.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @doing_tasks = Task.kanban_doing.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @done_tasks  = Task.kanban_done.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })

    @hold_count  = Task.where(task_status_id: TaskStatus::HOLD.id).count
  end

  def update
  end
end
