class Schedules::WorkersController < ApplicationController
  before_action :set_schedule, only: [:new, :create]

  def new
  end

  def create
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:schedule_id]).decorate
    @schedule_workers = @schedule.model.schedule_workers
    @sections = Section.usual.pluck(:name, :id).unshift(['すべて', 0])
  end
end
