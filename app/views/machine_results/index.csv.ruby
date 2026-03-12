require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  cols = {
    MachineResult.human_attribute_name(:owner_name) => ->(m){ m.owner.name },
    MachineResult.human_attribute_name(:machine_type_name) => ->(m){ m.machine.machine_type.name },
    MachineResult.human_attribute_name(:worked_at) => ->(m){ m.work.worked_at },
    MachineResult.human_attribute_name(:work_type_name) => ->(m){ "#{m.work.work_type&.category_name}(#{m.work.work_type&.name})" },
    MachineResult.human_attribute_name(:work_name) => ->(m){ "#{m.work&.work_kind&.name}(#{m.work&.name})" },
    MachineResult.human_attribute_name(:price) => ->(m){ m.price },
    MachineResult.human_attribute_name(:quantity) => ->(m){ m.quantity },
    MachineResult.human_attribute_name(:adjust_unit) => ->(m){ m.adjust.unit },
    MachineResult.human_attribute_name(:amount) => ->(m){ m.amount }
  }
  csv << cols.keys
  @results.each do |result|
    csv << cols.map{|_k, col| col.call(result)}
  end
end

NKF.nkf('--sjis -Lw', csv_str)
