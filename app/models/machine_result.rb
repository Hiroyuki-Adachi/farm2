# == Schema Information
#
# Table name: machine_results
#
#  id              :integer          not null, primary key
#  machine_id      :integer
#  work_result_id  :integer
#  display_order   :integer          default(1), not null
#  hours           :decimal(3, 1)    default(0.0), not null
#  fixed_quantity  :decimal(5, 2)
#  fixed_adjust_id :integer
#  fixed_price     :decimal(5, )
#  fixed_amount    :decimal(7, )
#  created_at      :datetime
#  updated_at      :datetime
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
    .joins("INNER JOIN machine_types ON machine_types.id = machines.machine_type_id")
    .joins("INNER JOIN systems ON systems.term = works.term")
    .where("systems.target_from <= works.worked_at and works.worked_at <= systems.target_to")
    .where("homes.company_flag = FALSE AND systems.term = ?", term)
    .order("homes.display_order, homes.id, machines.display_order, machines.id, works.worked_at, works.id")
  }
  
  def price
    calc_amount unless @price
    return @price
  end
  
  def adjust
    calc_amount unless @adjust
    return @adjust
  end
  
  def quantity
    calc_amount unless @quantity
    return @quantity
  end
  
  def amount
    calc_amount unless @amount
    return @amount
  end
  
  private
  def calc_amount
    price_details = machine.price_details(work)
    unless price_details
      clear_amount
      return
    end

    if owner.id == work_result.worker_id
      price_details = price_details.where(lease_id: Lease::NORMAL)
    else
      price_details = price_details.where(lease_id: Lease::LEASE)
    end
    unless price_details.exists?
      clear_amount
      return
    end

    if price_details.where(work_kind_id: work.work_kind.id).exists?
      price_details = price_details.where(work_kind_id: work.work_kind.id)
    else
      price_details = price_details.where(work_kind_id: 0)
    end
    unless price_details.exists?
      clear_amount
      return
    end

    price_detail = price_details.first
    @adjust = price_detail.adjust
    if @adjust == Adjust::NONE
      clear_amount
      return
    end

    @price = price_detail.price
    @quantity = case @adjust 
      when Adjust::HOUR
        work.sum_hours
      when Adjust::AREA
        work.sum_areas / 10
      when Adjust::DAY
        1
      end
    @amount = @price * @quantity 
  end

  def clear_amount
    @price = 0
    @adjust = Adjust::NONE
    @quantity = 0
    @amount = 0
  end
end
