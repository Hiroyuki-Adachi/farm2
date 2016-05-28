# == Schema Information
#
# Table name: machines
#
#  id                :integer          not null, primary key
#  name              :string(40)       not null
#  display_order     :integer          not null
#  validity_start_at :date
#  validity_end_at   :date
#  machine_type_id   :integer          default(0), not null
#  home_id           :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#  deleted_at        :datetime
#

class Machine < ActiveRecord::Base
  acts_as_paranoid

  has_many  :machine_results
  has_many  :work_results, through: :machine_results, dependent: :restrict_with_exception

  belongs_to :machine_type
  has_many :machine_kinds, through: :machine_type

  belongs_to :owner, {class_name: :Home, foreign_key: :home_id}, -> {with_deleted}

  validates :validity_start_at, presence: true
  validates :validity_end_at, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  scope :by_work, -> (work) { 
     includes(:machine_type, :machine_kinds)
    .where("machine_kinds.work_kind_id = ? and validity_start_at < ? and ? < validity_end_at", work.work_kind_id, work.worked_at, work.worked_at)
    .order("machines.display_order")
  }

  scope :by_results, -> (results) {
    joins(:machine_results)
    .where('machine_results.work_result_id in (?)', results.pluck(:id))
    .order('machines.display_order').uniq
  }
  
  scope :usual, -> {includes(:machine_type).order("machine_types.display_order, machines.display_order, machines.id")}

  def operators(work)
    operators = []
    work.work_results.each do |result|
      operators << result.worker.home.name if self.work_results.include?(result)
    end

    return operators.join(',')
  end
  
  def hours(results)
    return MachineResult.where("machine_id = ? and work_result_id in (?)", self.id, results.pluck(:id)).sum(:hours)
  end
  
  def owner_name
    return self.owner ? self.owner.name : ""
  end
  
  def type_name
    return self.machine_type ? self.machine_type.name : ""
  end
  
  def usual_name
    return self.owner.company_flag ? "#{type_name}(#{self.name})" : "#{type_name}(#{owner_name})"
  end
end
