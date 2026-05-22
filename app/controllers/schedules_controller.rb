class SchedulesController < ApplicationController
  include ReturnToIndex

  before_action :set_schedule, only: [:edit, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :permit_only_self, only: [:edit, :update, :destroy]
  keeps_index_return_to path_method: :schedules_path

  def index
    @schedules = Schedule.for_organization(current_organization).usual
    @schedules = @schedules.by_worker(current_user.worker) unless current_user.admin?
    @schedules = ScheduleDecorator.decorate_collection(@schedules.page(params[:page] || 1))
  end

  def new
    @schedule = Schedule.new(
      worked_at: Time.zone.today,
      work_type_id: @work_types.first.id,
      term: 0,
      work_flag: true,
      farming_flag: true,
      line_flag: true,
      minutes_flag: true,
      calendar_remove_flag: false,
      organization_id: current_organization.id
    ).decorate
  end

  def edit; end

  def create
    @schedule = Schedule.new(schedule_params.merge(created_by: current_user.worker.id, organization_id: current_organization.id))
    Schedule.transaction do
      if @schedule.save
        @schedule.regist_sections(params[:section_ids])
        redirect_to @return_to
      else
        @schedule = @schedule.decorate
        render action: :new, status: :unprocessable_content
      end
    end
  end

  def update
    Schedule.transaction do
      if @schedule.update(schedule_params)
        @schedule.model.regist_sections(params[:section_ids])
        redirect_to @return_to
      else
        render action: :edit, status: :unprocessable_content
      end
    end
  end

  def destroy
    @schedule.destroy
    redirect_to @return_to, status: :see_other
  end

  def work_types
    @available_schedule_systems = available_schedule_systems
    @schedule_work_type_term = schedule_work_type_term(params[:term])
    @work_types = schedule_work_types(@schedule_work_type_term)
    @work_type_id = selected_work_type_id(@work_types, params[:work_type_id])
    @work_kinds = work_kinds_for(@work_type_id)

    render turbo_stream: [
      turbo_stream.replace(
        "schedule_work_types",
        partial: "schedules/work_types",
        locals: {
          work_types: @work_types,
          selected_work_type_id: @work_type_id
        }
      ),
      turbo_stream.update("work_kind_id") do
        helpers.options_from_collection_for_select(@work_kinds, :id, :name)
      end
    ]
  end

  private

  def set_schedule
    @schedule = Schedule.for_organization(current_organization).find(params[:id]).decorate
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
      .merge(term: 0)
  end

  def set_masters
    @available_schedule_systems = available_schedule_systems
    @schedule_work_type_term = schedule_work_type_term(params[:schedule_work_type_term])
    @work_types = schedule_work_types(@schedule_work_type_term)
    @work_type_id = selected_work_type_id(@work_types, @schedule&.work_type_id)
    @work_kinds = work_kinds_for(@work_type_id)
    @sections = Section.for_organization(current_organization).usual_order
  end

  def available_schedule_systems
    systems = [current_system]
    systems << next_system if next_system

    schedule_system = current_organization.get_system(schedule_worked_at)
    systems << schedule_system if schedule_system

    systems.compact.uniq(&:term).sort_by(&:term)
  end

  def schedule_work_type_term(term)
    term = term.presence&.to_i
    return term if @available_schedule_systems&.any? { |system| system.term == term }

    schedule_term = current_organization.get_term(schedule_worked_at)
    return schedule_term if @available_schedule_systems&.any? { |system| system.term == schedule_term }

    current_term
  end

  def schedule_worked_at
    schedule = @schedule&.respond_to?(:model) ? @schedule.model : @schedule
    schedule&.worked_at
  end

  def schedule_work_types(term)
    WorkType.usual.by_term(term).includes(genre: :category)
  end

  def selected_work_type_id(work_types, work_type_id)
    work_type_id = work_type_id.presence&.to_i
    return work_type_id if work_types.any? { |work_type| work_type.id == work_type_id }

    work_types.first&.id
  end

  def schedule_term_label(system)
    return "今年度" if system.term == current_term
    return "翌年度" if system.term == next_term

    "#{system.term}年度"
  end
  helper_method :schedule_term_label

  def work_kinds_for(work_type_id)
    return [] if work_type_id.blank?

    WorkKind.by_type(WorkType.find(work_type_id)) || []
  end

  def permit_only_self
    return true if current_user.admin?

    if (current_user.worker.id == @schedule.created_by) || @schedule.workers.any? { |w| w.id == current_user.worker.id }
      true
    else
      to_error_path
    end
  end
end
