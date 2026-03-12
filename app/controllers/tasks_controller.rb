class TasksController < ApplicationController
  include PermitChecker

  before_action :set_task, only: [:show, :destroy]

  helper_method :back_path

  helper MarkdownHelper

  decorates_assigned :task, :tasks

  def index
    @tasks = Task
              .for_index
              .includes(:assignee)
              .with_watch_flag(current_user.worker.id)
              .with_unread_count(current_user.worker.id)
  end

  def new
    @task = Task.new
    unless current_user.worker.office_role_none?
      @task.assignee = current_user.worker
      @task.office_role = current_user.worker.office_role
    end
    @templates = TaskTemplateDecorator.decorate_collection(TaskTemplate.for_hand_creation)
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user.worker 

    if @task.save
      redirect_to tasks_path, notice: "タスクを作成しました。"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @last_read_at = TaskRead.touch_and_get_previous!(task: @task, worker_id: current_user.worker_id)
  end

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
        :assignee_id,
        :task_template_id
      ])
  end

  def set_task
    @task = 
      if params[:task_id]
        Task.find(params[:task_id])
      else
        Task.includes(:assignee, :creator).find(params[:id])
      end
  end

  def task_comment
    params[:task][:comment]
  end

  def back_path
    case params[:from] 
    when "kanban" then tasks_kanbans_path 
    when "gantt" then tasks_gantts_path 
    else tasks_path
    end
  end
end
