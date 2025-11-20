class Tasks::KanbansController < ApplicationController
  include PermitChecker

  def show
    @todo_tasks  = Task.kanban_todo.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @doing_tasks = Task.kanban_doing.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @done_tasks  = Task.kanban_done.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
  end

  def update
    columns = params[:columns] || []

    Task.transaction do
      columns.each do |col|
        kanban_column = col[:task_kanban_column]
        (col[:task_ids] || []).each_with_index do |task_id, idx|
          Task.find(task_id).move_on_kanban!(kanban_column.to_i, idx, actor: current_user.worker)
        end
      end
    end

    head :ok
  end
end
