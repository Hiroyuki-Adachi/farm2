# == Schema Information
#
# Table name: machine_results
#
#  id             :integer          not null, primary key
#  machine_id     :integer
#  work_result_id :integer
#  display_order  :integer          default(1), not null
#  hours          :decimal(3, 1)    default(0.0), not null
#  areas          :decimal(6, 2)    default(0.0), not null
#  lease_id       :integer          default(0), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class MachineResult < ActiveRecord::Base
  belongs_to  :machine, -> {with_deleted}
  belongs_to  :work_result

  has_one     :work, {through: :work_result}, -> {with_deleted}
  has_one     :owner, {through: :machine}, -> {with_deleted}
  has_one     :work_type, {through: :work}, -> {with_deleted}
  has_one     :machine_type, {through: :machine}, -> {with_deleted}
  
  scope :by_home, ->(term) {
     joins(:machine).eager_load(:machine)
    .joins(:work_result).eager_load(:work_result)
    .joins(:work_type).eager_load(:work_type)
    .joins("INNER JOIN homes ON homes.id = machines.home_id").preload(:owner)
    .joins("INNER JOIN systems ON systems.term = works.term")
    .where("systems.target_from <= works.worked_at and works.worked_at <= systems.target_to")
    .where("homes.company_flag = FALSE AND systems.term = ?", term)
    .order("homes.display_order, homes.id, work_types.display_order, machines.display_order, machines.id, works.worked_at, works.id")
  }
  
  def price
  end
  
  def adjust
  end
  
  def quantity
  end
  
  def amount
  end
  
  private
  def calc_amount
    
  end
end
