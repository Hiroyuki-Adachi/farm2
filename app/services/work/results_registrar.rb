class Work::ResultsRegistrar
  def initialize(work, params, current_worker)
    @work = work
    @params = params
    @current_worker = current_worker
  end

  def call
    workers = []
    if @params.present?
      @params.each do |param|
        worker_id = param[:worker_id].to_i
        workers << worker_id
        display_order = param[:display_order].to_i
        hours = param[:hours].to_f
        work_result = @work.work_results.find_by(worker_id: worker_id)
        if work_result
          Rails.application.config.update_logger.info "updated:#{work_result.worker.name}:#{work_result.hours}:#{hours}" if work_result.hours != hours

          work_result.update(display_order: display_order, hours: hours) if work_result.display_order != display_order || work_result.hours != hours
        else
          WorkResult.create(work_id: @work.id, worker_id: worker_id, display_order: display_order, hours: hours)
        end
      end
    end

    @work.work_results.where.not(worker_id: workers).destroy_all

    WorkVerification.regist(@work, @current_worker)

    @work.printed_at = nil
    @work.printed_by = nil
    @work.save!
  end
end
