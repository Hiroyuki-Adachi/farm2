class Schedules::WorkersController < ApplicationController
  include PermitUser
  before_action :set_schedule, only: [:new, :create]

  def new; end

  def create
    @schedule.regist_workers(params[:schedule_workers])
    redirect_to(schedules_path)
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:schedule_id]).decorate
    @schedule_workers = @schedule.model.schedule_workers
    @sections = Section.usual.pluck(:name, :id).unshift(['すべて', 0])
  end

  def menu_name
    return "schedules"
  end
end
