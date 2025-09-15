class TasksController < ApplicationController
  include PermitChecker

  before_action :set_task, only: [:show, :destroy]

  helper TasksHelper
  helper MarkdownHelper

  decorates_assigned :task, :tasks

  def index
    @tasks = Task.for_index.includes(:assignee).with_watch_flag(current_user.worker.id).page(params[:page])
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

  def show; end

  def destroy
    to_error_path unless @task.deletable?(current_user)
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました。"
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

  def set_task
    @task = 
      if params[:id]
        Task.includes(:assignee, :creator).find(params[:id])
      else
        Task.find(params[:task_id])
      end
  end

  def task_comment
    params[:task][:comment]
  end
end
