class PersonalInformations::Schedules::WorkersController < PersonalInformationsController
  before_action :set_schedule, only: [:edit, :update]
  before_action :set_workers, only: [:edit, :update]

  def index
    @schedules = ScheduleDecorator.decorate_collection(
      Schedule
        .for_organization(@worker.organization_id)
        .by_section(@worker.home.section_id)
        .within_days_from_today(SCHEDULE_WORKERS_DAY)
    )
  end

  def edit
    @selected_worker_ids = @schedule.schedule_workers.where(worker_id: editable_worker_ids).pluck(:worker_id)
  end

  def update
    checked_ids = Array(params[:worker_ids]).each_with_object({}) do |worker_id, ids|
      ids[worker_id.to_i] = true
    end
    selected_ids = editable_worker_ids.select { |worker_id| checked_ids[worker_id] }

    sync_schedule_workers!(selected_ids, editable_worker_ids)

    redirect_to personal_information_schedules_workers_path(personal_information_token: params[:personal_information_token])
  end

  private

  def set_schedule
    @schedule = Schedule.for_organization(@worker.organization_id).find_by(id: params[:schedule_id])
    return to_error_path if @schedule.blank?
    return if @schedule.schedule_sections.exists?(section_id: @worker.home.section_id)

    to_error_path
  end

  def set_workers
    @workers = if permitted_position?
                 workers_for_sections([@worker.home.section_id])
               else
                 Worker.for_organization(@worker.organization_id).usual_order.workable.where(home_id: @worker.home_id)
               end

    @section_worker_management = permitted_position?
    @supporter_sections = @section_worker_management ? supporter_sections : []

    supporter_section_ids = @supporter_sections.map(&:id)
    supporter_workers = supporter_section_ids.any? ? workers_for_sections(supporter_section_ids) : []
    supporter_workers_by_section_id = supporter_workers.group_by { |w| w.home.section_id }

    @supporter_workers_by_section = @supporter_sections.index_with do |section|
      supporter_workers_by_section_id[section.id] || []
    end
  end

  def permitted_position?
    @worker.leader? || @worker.director? || @worker.advisor?
  end

  def target_section_ids
    @target_section_ids ||= @schedule.section_ids
  end

  def supporter_sections
    Section
      .for_organization(@worker.organization_id)
      .usual
      .where.not(id: target_section_ids)
  end

  def workers_for_sections(section_ids)
    Worker
      .for_organization(@worker.organization_id)
      .usual_order
      .workable
      .where(homes: { section_id: section_ids, company_flag: false })
  end

  def editable_worker_ids
    @editable_worker_ids ||= begin
      ids = @workers.pluck(:id)
      ids += @supporter_workers_by_section.values.flat_map { |workers| workers.pluck(:id) }
      ids.uniq
    end
  end

  def sync_schedule_workers!(selected_ids, editable_worker_ids)
    ActiveRecord::Base.transaction do
      records = @schedule.schedule_workers.where(worker_id: editable_worker_ids).index_by(&:worker_id)

      (records.keys - selected_ids).each do |worker_id|
        records[worker_id].destroy!
      end

      selected_ids.each_with_index do |worker_id, index|
        display_order = index + 1
        record = records[worker_id]
        if record.present?
          record.update!(display_order: display_order) if record.display_order != display_order
        else
          @schedule.schedule_workers.create!(worker_id: worker_id, display_order: display_order)
        end
      end
    end
  end
end
