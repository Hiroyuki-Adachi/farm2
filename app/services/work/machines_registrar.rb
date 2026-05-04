class Work::MachinesRegistrar
  def initialize(params)
    @params = params
  end

  def call
    @params.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        hour = hour.to_f
        machine_result = MachineResult.find_by(work_result_id: work_result_id, machine_id: machine_id)
        if machine_result
          if hour.positive?
            machine_result.update(hours: hour) if machine_result.hours != hour
          else
            machine_result.destroy
          end
        elsif hour.positive?
          MachineResult.create(work_result_id: work_result_id, machine_id: machine_id, hours: hour)
        end
      end
    end
  end
end
