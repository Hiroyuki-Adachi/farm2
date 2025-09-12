class TasksController < ApplicationController
  include PermitChecker

  helper TasksHelper

  def index
    @tasks = TaskDecorator.decorate_collection(Task.for_index.includes(:assignee).page(params[:page]))
  end
end
