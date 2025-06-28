class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :permit_not_manager, except: [:index]

  def index
    @schedules = Schedule.includes(workers: :home).usual
    @schedules = @schedules.by_worker(current_user.worker) unless current_user.checkable?
    @schedules = ScheduleDecorator.decorate_collection(@schedules.page(params[:page] || 1))
  end

  def new
    @schedule = Schedule.new(
      worked_at: Time.zone.today,
      work_type_id: @work_types.first.id,
      term: 0,
      work_flag: true,
    ).decorate
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to(new_schedule_worker_path(schedule_id: @schedule))
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @schedule.update(schedule_params)
      redirect_to(schedules_path)
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy
    redirect_to schedules_path, status: :see_other
  end
  
  private

  def set_schedule
    @schedule = Schedule.find(params[:id]).decorate
  end

  def schedule_params
    params.expect(
      schedule: [
        :worked_at,
        :work_type_id,
        :work_kind_id,
        :name,
        :work_flag,
        :start_at,
        :end_at,
        :calendar_remove_flag,
        :farming_flag,
        :line_flag,
        :minutes_flag
      ]
    )
  end

  def set_masters
    @work_types = WorkType.usual
    @work_kinds = WorkKind.by_type(@schedule ? @schedule.work_type : @work_types.first) || []
  end

  def permit_not_manager
    to_error_path unless current_user.manageable?
  end
end
