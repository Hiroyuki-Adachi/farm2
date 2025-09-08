class TasksController < ApplicationController
  include PermitChecker

  helper TasksHelper

  def index
    @tasks = Task.for_index.page(params[:page])
  end
end
