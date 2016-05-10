class MachineResult < ActiveRecord::Base
  belongs_to  :machine
  belongs_to  :work_result

  def self.list_machine
    sql =<<-SQL
    SELECT DISTINCT machines.id, machines.name, machines.display_order FROM machines
      INNER JOIN machine_results ON machine_results.machine_id = machines.id AND machine_results.hours > 0
      INNER JOIN work_results ON machine_results.work_result_id = work_results.id
      INNER JOIN works ON work_results.work_id = works.id
      INNER JOIN systems ON works.year = systems.term AND works.worked_at >= systems.target_from AND works.worked_at <= systems.target_to
      ORDER BY machines.display_order, machines.id
SQL
    return Machine.find_by_sql(sql)
  end
end
