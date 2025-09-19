# app/controllers/tasks/event_comments_controller.rb
class Tasks::EventCommentsController < TasksController
  before_action :set_task
  before_action :set_event

  def show
    @comment = @event.comment
    if @comment.present?
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/show_for_event",
        locals: { task: @task, event: @event, comment: @comment }
      )
    else
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/empty_for_event",
        locals: { task: @task, event: @event }
      )
    end
  end

  def edit
    @comment = @event.comment || TaskComment.new(event: @event, poster: current_user.worker)
    render turbo_stream: turbo_stream.update(
      helpers.dom_id(@event, :comment),
      partial: "tasks/comments/edit_for_event",
      locals: { task: @task, event: @event, comment: @comment }
    )
  end

  def create
    return update if @event.comment.present?

    @comment = @task.comments.build(comment_params.merge(poster: current_user.worker))
    ActiveRecord::Base.transaction do
      @comment.save!
      @event.update!(comment: @comment) 
    end

    render turbo_stream: turbo_stream.update(
      helpers.dom_id(@event, :comment),
      partial: "tasks/comments/show_for_event",
      locals: { task: @task, event: @event, comment: @comment }
    )
  rescue ActiveRecord::RecordInvalid
    render turbo_stream: turbo_stream.update(
      helpers.dom_id(@event, :comment),
      partial: "tasks/comments/edit_for_event",
      locals: { task: @task, event: @event, comment: @comment },
      status: :unprocessable_content
    )
  end

  def update
    @comment = @event.comment or return create
    unless authorize_comment_owner?(@comment)
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/edit_for_event",
        locals: { task: @task, event: @event, comment: @comment },
        status: :unprocessable_content
      )
    end

    if @comment.update(comment_params)
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/show_for_event",
        locals: { task: @task, event: @event, comment: @comment }
      )
    else
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/edit_for_event",
        locals: { task: @task, event: @event, comment: @comment },
        status: :unprocessable_content
      )
    end
  end

  def destroy
    @comment = @event.comment
    unless authorize_comment_owner?(@comment)
      render turbo_stream: turbo_stream.update(
        helpers.dom_id(@event, :comment),
        partial: "tasks/comments/edit_for_event",
        locals: { task: @task, event: @event, comment: @comment },
        status: :unprocessable_content
      )
    end
    @comment.destroy!

    # コメント部位だけ“未付与表示”に戻す
    render turbo_stream: turbo_stream.update(
      helpers.dom_id(@event, :comment),
      partial: "tasks/comments/empty_for_event",
      locals: { task: @task, event: @event }
    )
  end

  private

  def set_event
    @event = @task.events.find(params[:event_id])
  end

  def authorize_comment_owner?(comment)
    comment.poster_id == current_user.worker_id
  end

  def comment_params
    params.expect(task_comment: [:body])
  end
end
