class PersonalInformations::Schedules::WorkersController < PersonalInformationsController
  before_action :set_schedule, only: [:edit, :update]
  before_action :set_workers, only: [:edit, :update]

  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.for_organization(@worker.organization_id).by_section(@worker.home.section_id))
  end

  def edit
    @selected_worker_ids = @schedule.schedule_workers.where(worker_id: @workers.pluck(:id)).pluck(:worker_id)
  end

  def update
    section_worker_ids = @workers.pluck(:id)
    checked_ids = Array(params[:worker_ids]).map(&:to_i)
    selected_ids = section_worker_ids.select { |worker_id| checked_ids.include?(worker_id) }

    sync_schedule_workers!(selected_ids, section_worker_ids)

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
                 Worker.usual_order.where(homes: {section_id: @worker.home.section_id, company_flag: false})
               else
                 Worker.usual_order.where(home_id: @worker.home_id)
               end
  end

  def permitted_position?
    @worker.leader? || @worker.director? || @worker.advisor?
  end

  def sync_schedule_workers!(selected_ids, section_worker_ids)
    ActiveRecord::Base.transaction do
      records = @schedule.schedule_workers.where(worker_id: section_worker_ids).index_by(&:worker_id)

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
