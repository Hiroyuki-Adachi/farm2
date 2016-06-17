# == Schema Information
#
# Table name: machine_results # 機械稼動データ
#
#  id              :integer          not null, primary key  # 機械稼動データ
#  machine_id      :integer                                 # 機械
#  work_result_id  :integer                                 # 作業結果データ
#  display_order   :integer          default(1), not null   # 表示順
#  hours           :decimal(3, 1)    default(0.0), not null # 稼動時間
#  fixed_quantity  :decimal(5, 2)                           # 確定稼動量
#  fixed_adjust_id :integer                                 # 確定稼動単位
#  fixed_price     :decimal(5, )                            # 確定稼動単価
#  fixed_amount    :decimal(7, )                            # 確定使用料
#  created_at      :datetime
#  updated_at      :datetime
#

class MachineResult < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to  :machine, -> {with_deleted}
  belongs_to  :work_result
  belongs_to  :fixed_adjust, {class_name: "Adjust"}

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
    .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
    .where("homes.company_flag = FALSE")
    .where("systems.term = ?", term)
    .order("homes.display_order, homes.id, machines.display_order, machines.id, works.worked_at, works.id")
  }

  scope :by_home_for_fix, ->(term, fixed_at) {
     joins(:machine).eager_load(:machine)
    .joins(:work_result).eager_load(:work_result)
    .joins(:work_type).eager_load(:work_type)
    .joins("INNER JOIN homes ON homes.id = machines.home_id").preload(:owner)
    .joins("INNER JOIN machine_types ON machine_types.id = machines.machine_type_id")
    .where("homes.company_flag = FALSE AND works.term = ?", term)
    .where("works.fixed_at = ? AND machine_results.fixed_price IS NOT NULL", fixed_at)
    .order("homes.display_order, homes.id, machines.display_order, machines.id, works.worked_at, works.id")
  }
  
  def price
    @price = fixed_price if work.fixed_at
    calc_amount unless @price
    return @price
  end
  
  def adjust
    @adjust = fixed_adjust if work.fixed_at
    calc_amount unless @adjust
    return @adjust
  end
  
  def quantity
    @quantity = fixed_quantity if work.fixed_at
    calc_amount unless @quantity
    return @quantity
  end
  
  def amount
    @amount = fixed_amount if work.fixed_at
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

      if owner.id == work_result.worker.home_id
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
