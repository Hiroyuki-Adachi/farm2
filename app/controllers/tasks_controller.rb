class TasksController < ApplicationController
  include PermitChecker

  helper TasksHelper
  helper MarkdownHelper

  def index
    @tasks = Task.for_index.includes(:assignee).with_watch_flag(current_user.worker.id).page(params[:page])
    @tasks = TaskDecorator.decorate_collection(@tasks)
  end

  def new
    @task = Task.new
    unless current_user.worker.office_role_none?
      @task.assignee = current_user.worker
      @task.office_role = current_user.worker.office_role
    end
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user.worker 

    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.expect(task: 
      [
        :title,
        :description,
        :task_status_id,
        :priority,
        :due_on,
        :started_on,
        :ended_on,
        :end_reason,
        :office_role,
        :assignee_id
      ])
  end
end
