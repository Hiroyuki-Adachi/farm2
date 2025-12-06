class Tasks::GanttsController < ApplicationController
  include PermitChecker

  before_action :set_dates

  def show
    worker = current_user.worker
    @tasks = Task.by_worker(worker).for_gantt(@start_date, @end_date).gantts_order.decorate(context: { current_worker: worker })
  end

  def update
    task = Task.find_by(id: params[:task_id])
    return head :not_found unless task

    date = begin
      Date.parse(params[:date])
    rescue StandardError
      nil
    end
    return head :unprocessable_content unless date

    case params[:edge].to_sym
    when :start
      date = task.due_on if task.due_on && date > task.due_on
      task.update!(planned_start_on: date)
    when :end
      date = task.planned_start_on if date < task.planned_start_on
      task.change_due_on!(date, current_user.worker, source: :gantt)
    else
      return head :unprocessable_content
    end

    @task = task.decorate(context: { current_worker: current_user.worker })

    respond_to do |format|
      format.turbo_stream
    end
  rescue StandardError => e
    respond_to do |format|
      format.turbo_stream { render plain: "Error updating gantt: #{e.message}", status: :unprocessable_content }
    end
  end

  private

  def set_dates
    @start_date = Date.current.prev_month.beginning_of_month
    @end_date   = Date.current.advance(months: 2).end_of_month
    @dates      = (@start_date..@end_date).to_a
  end

  def menu_name
    :tasks
  end
end
