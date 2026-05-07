class Schedules::WorkersController < ApplicationController
  include PermitUser
  include ReturnToIndex

  before_action :set_schedule, only: [:new, :create]
  keeps_index_return_to path_method: :schedules_path, only: [:new, :create]

  def new; end

  def create
    @schedule.regist_workers(params[:schedule_workers])
    redirect_to(@return_to)
  end

  private

  def set_schedule
    @schedule = Schedule.for_organization(current_organization).find(params[:schedule_id]).decorate
    @schedule_workers = @schedule.model.schedule_workers
    @sections = Section.for_organization(current_organization).usual.pluck(:name, :id).unshift(['すべて', 0])
  end

  def menu_name
    "schedules"
  end
end
