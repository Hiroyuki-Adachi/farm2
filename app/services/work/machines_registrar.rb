class Work::MachinesRegistrar
  def initialize(work, params)
    @work = work
    @params = params
  end

  def call
    @params.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        target_work_result = @work.work_results.find_by(id: work_result_id)
        next unless target_work_result

        hour = hour.to_f
        machine_result = @work.machine_results.find_by(work_result_id: target_work_result.id, machine_id: machine_id)
        if machine_result
          if hour.positive?
            machine_result.update(hours: hour) if machine_result.hours != hour
          else
            machine_result.destroy
          end
        elsif hour.positive?
          MachineResult.create(work_result_id: target_work_result.id, machine_id: machine_id, hours: hour)
        end
      end
    end
  end
end
