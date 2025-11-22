class Tasks::KanbansController < ApplicationController
  include PermitChecker

  def show
    @todo_tasks  = Task.kanban_todo.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @doing_tasks = Task.kanban_doing.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
    @done_tasks  = Task.kanban_done.by_worker(current_user.worker).kanban_order.decorate(context: { current_worker: current_user.worker })
  end

  def update
    columns = params[:columns] || []
    changed_task_ids = []

    begin
      Task.transaction do
        columns.each do |col|
          kanban_column = col[:task_kanban_column]
          (col[:task_ids] || []).each_with_index do |task_id, idx|
            next unless (task = Task.find_by(id: task_id))
            task.move_on_kanban!(kanban_column.to_i, idx, actor: current_user.worker)
            changed_task_ids << task.id
          end
        end
      end

      @tasks = Task.where(id: changed_task_ids)
                   .kanban_order
                   .decorate(context: { current_worker: current_user.worker })

      respond_to do |format|
        format.turbo_stream
        format.json { head :ok }
        format.html { head :ok }
      end
    rescue => e
      respond_to do |format|
        format.turbo_stream { render plain: "Error updating kanban: #{e.message}", status: :unprocessable_entity }
        format.json { render json: { error: "Error updating kanban: #{e.message}" }, status: :unprocessable_entity }
        format.html { render plain: "Error updating kanban: #{e.message}", status: :unprocessable_entity }
      end
    end
end
