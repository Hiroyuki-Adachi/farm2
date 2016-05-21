class Machine < ActiveRecord::Base
  has_many  :machine_results
  has_many  :work_results, through: :machine_results

  belongs_to :machine_type
  has_many :machine_kinds, through: :machine_type

  belongs_to :home

  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  scope :by_work, -> (work) { 
     includes(:machine_type, :machine_kinds)
    .where("machine_kinds.work_kind_id = ? and validity_start_at < ? and ? < validity_end_at", work.work_kind_id, work.worked_at, work.worked_at)
    .order("machines.display_order")
  }

  scope :by_results, -> (results) {
    includes(:machine_results)
    .where('machine_results.work_result_id in (?)', results)
    .order('machines.display_order')
  }

  def operators_format(work)
    operators = []
    work.work_results.each do |result|
      operators << result.worker.name if self.work_results.include?(result)
    end

    return operators.join('、')
  end

  def hours_format(results)
    return sprintf("%.1f", MachineResult.sum(:hours).where("machine_id = ? and work_result_id in (?)", self.id, results))
  end
end
