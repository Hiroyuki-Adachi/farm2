# app/controllers/tasks/comments_controller.rb
class Tasks::CommentsController < TasksController
  before_action :set_task

  def create
    @event = @task.add_comment!(actor: current_user.worker, body: comment_params[:body])

    render turbo_stream: [
      # タイムライン末尾に追記（or 時系列順に並べ替えなら replace で全体描画でもOK）
      turbo_stream.append(
        "task_timeline",
        partial: "tasks/events/item",
        locals: { event: @event.decorate(context: { current_worker: current_user.worker }), mine: true }
      ),
      # 入力欄クリア
      turbo_stream.update(
        "new_comment",
        partial: "tasks/comments/new_form",
        locals: { task: @task, comment: TaskComment.new(task_id: @task) }
      )
    ]
  rescue ActiveRecord::RecordInvalid
    render partial: "tasks/comments/new_form",
           locals: { task: @task, comment: @event.comment },
           status: :unprocessable_content
  end

  private

  def comment_params
    params.expect(task_comment: [:body])
  end
end
