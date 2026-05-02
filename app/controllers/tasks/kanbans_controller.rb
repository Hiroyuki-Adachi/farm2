class Tasks::KanbansController < ApplicationController
  include PermitChecker

  def show
    tasks = Task.for_organization(current_organization)
    @todo_tasks  = tasks.kanban_todo.planned_start.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @doing_tasks = tasks.kanban_doing.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @done_tasks  = tasks.kanban_done.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
  end

  def update
    columns = params[:columns] || []
    changed_task_ids = []

    Task.transaction do
      columns.each do |col|
        kanban_column = col[:task_kanban_column]
        (col[:task_ids] || []).each_with_index do |task_id, idx|
          next unless (task = Task.for_organization(current_organization).find_by(id: task_id))
          task.move_on_kanban!(kanban_column.to_i, idx, actor: current_user.worker)
          changed_task_ids << task.id
        end
      end
    end

    @tasks = Task.for_organization(current_organization).where(id: changed_task_ids)
                  .kanban_order
                  .decorate(context: { current_worker: current_user.worker })

    respond_to do |format|
      format.turbo_stream
      format.json { head :ok }
      format.html { head :ok }
    end
  rescue StandardError => e
    respond_to do |format|
      format.turbo_stream { render plain: "Error updating kanban: #{e.message}", status: :unprocessable_entity }
      format.json { render json: { error: "Error updating kanban: #{e.message}" }, status: :unprocessable_entity }
      format.html { render plain: "Error updating kanban: #{e.message}", status: :unprocessable_entity }
    end
  end

  private

  def menu_name
    :tasks
  end
end
