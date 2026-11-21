class Work::MachinesRegistrar
  def initialize(work, params, amounts = {})
    @work = work
    @params = params
    @amounts = amounts
  end

  def call
    MachineResult.transaction do
      save_hours
      save_amounts
      (@params.keys + @amounts.keys).uniq.each do |machine_id|
        unless @work.machine_results.exists?(machine_id: machine_id)
          @work.machine_remarks.where(machine_id: machine_id).destroy_all
        end
      end
    end
    @work.errors.empty?
  end

  private

  def entry_for(machine_id, result_id)
    target = @work.work_results.find_by(id: result_id)
    return unless target

    @work.machine_results.find_or_initialize_by(work_result_id: target.id, machine_id: machine_id)
  end

  def save_hours
    @params.each do |machine_id, results|
      results.each do |result_id, value|
        entry = entry_for(machine_id, result_id)
        next unless entry
        next if entry.direct_amount?

        hour = value.to_f
        if hour.positive?
          entry.update!(hours: hour, input_amount: nil)
        elsif entry.persisted?
          entry.destroy!
        end
      end
    end
  end

  def save_amounts
    @amounts.each do |machine_id, results|
      results.each do |result_id, value|
        entry = entry_for(machine_id, result_id)
        next unless entry&.direct_amount?

        if value.blank?
          entry.destroy! if entry.persisted?
        else
          validate_amount!(value)
          entry.update!(hours: 0, input_amount: value)
        end
      end
      validate_total!(machine_id)
    end
  end

  def validate_amount!(value)
    # DBのdecimalへの型変換で小数が丸められる前に検証する。
    return if /\A\d+\z/.match?(value.to_s) && value.to_i <= 9_999_999

    @work.errors.add(:base, "使用料は0〜9,999,999円の整数で入力してください。")
    raise ActiveRecord::Rollback
  end

  def validate_total!(machine_id)
    return if @work.machine_results.where(machine_id: machine_id).sum(:input_amount) <= 9_999_999

    @work.errors.add(:base, "同じ機械の使用料合計は9,999,999円以内で入力してください。")
    raise ActiveRecord::Rollback
  end
end
