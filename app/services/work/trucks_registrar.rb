class Work::TrucksRegistrar
  MIN_HOURS = BigDecimal("0")
  MAX_HOURS = BigDecimal("9.5")
  HOUR_STEP = BigDecimal("0.5")

  def initialize(machine_hours:, trucks:, work_results:)
    @machine_hours = machine_hours
    @trucks = trucks
    @work_results = work_results
  end

  def call
    ActiveRecord::Base.transaction do
      machine_hours.each do |machine_id, work_result_hours|
        save_machine_hours_for_machine(machine_id.to_i, work_result_hours)
      end
    end
  end

  private

  attr_reader :machine_hours, :trucks, :work_results

  def save_machine_hours_for_machine(machine_id, work_result_hours)
    truck = trucks.find { |current_truck| current_truck.id == machine_id }
    return unless truck

    work_result_hours.each do |work_result_id, hours_value|
      work_result = editable_work_result(work_result_id.to_i, truck)
      next unless work_result

      save_machine_result(machine_id, work_result.id, hours_value)
    end
  end

  def editable_work_result(work_result_id, truck)
    work_result = work_results.find { |result| result.id == work_result_id }
    return if work_result&.work&.fixed_at.present?
    return if work_result&.worker&.home_id != truck.home_id

    work_result
  end

  def save_machine_result(machine_id, work_result_id, hours_value)
    hours = parse_hours(hours_value)
    return unless valid_hours?(hours)

    machine_result = MachineResult.find_by(machine_id: machine_id, work_result_id: work_result_id)
    if hours.zero?
      machine_result&.destroy!
    elsif machine_result
      machine_result.update!(hours: hours)
    else
      MachineResult.create!(machine_id: machine_id, work_result_id: work_result_id, hours: hours)
    end
  end

  def valid_hours?(hours)
    hours&.finite? && hours.between?(MIN_HOURS, MAX_HOURS) && (hours % HOUR_STEP).zero?
  end

  def parse_hours(hours_value)
    BigDecimal(hours_value.to_s)
  rescue ArgumentError
    nil
  end
end
