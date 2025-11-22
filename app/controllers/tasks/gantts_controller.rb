class Tasks::GanttsController < ApplicationController
  include PermitChecker

  def show
    worker = current_user.worker

    @start_date = Date.current.prev_month.beginning_of_month
    @end_date   = Date.current.advance(months: 2).end_of_month
    @dates      = (@start_date..@end_date).to_a

    @tasks = Task.by_worker(worker).for_gantt(@start_date).gantts_order.decorate(context: { current_worker: worker })
  end

  def update
    task = Task.find_by(id: params[:task_id])
    return head :not_found unless task

    date = begin
      Date.parse(params[:date])
    rescue StandardError
      nil
    end
    return head :unprocessable_entity unless date

    case params[:edge]
    when "start"
      task.update!(planned_start_on: date)
    when "end"
      task.update!(due_on: date)
    else
      return head :unprocessable_entity
    end

    @task = task.decorate(context: { current_worker: current_user.worker })

    respond_to do |format|
      format.turbo_stream
    end
  end
end
