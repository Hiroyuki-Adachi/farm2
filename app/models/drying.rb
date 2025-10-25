# == Schema Information
#
# Table name: dryings(乾燥)
#
#  id                       :bigint           not null, primary key
#  carried_on(搬入日)       :date             not null
#  copy_flag(複写フラグ)    :integer          default(0), not null
#  fixed_amount(確定額)     :decimal(7, )
#  shipped_on(出荷日)       :date
#  term(年度(期))           :integer          not null
#  water_content(水分)      :decimal(3, 1)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  drying_type_id(乾燥種別) :integer          default("unset"), not null
#  home_id(担当世帯)        :integer          default(0), not null
#  work_type_id(作業分類)   :integer
#
# Indexes
#
#  dryings_secondary  (carried_on,home_id,copy_flag) UNIQUE
#

class Drying < ApplicationRecord
  KG_PER_BAG_RICE = 30
  KG_PER_BAG_WASTE = 25

  enum :drying_type_id, {unset: 0, country: 1, self: 2, another: 3, adjust: 4}

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  has_many   :drying_moths, dependent: :destroy
  has_many   :drying_lands, dependent: :destroy
  has_one    :adjustment,   dependent: :destroy

  after_save :delete_child

  accepts_nested_attributes_for :drying_moths
  accepts_nested_attributes_for :drying_lands
  accepts_nested_attributes_for :adjustment

  scope :by_home, ->(term, home) {
    left_joins(:adjustment)
      .where(["dryings.term = ? AND (dryings.home_id = ? OR adjustments.home_id = ?)", term, home.id, home.id])
      .order(:carried_on).order(:id)
  }

  scope :for_harvest, ->(term) {
    joins(:home, :work_type)
      .where(dryings: { term: term })
      .order(Arel.sql("work_types.display_order, dryings.carried_on, homes.drying_order, dryings.id"))
  }

  def rice_bag
    return (rice_weight || 0) / KG_PER_BAG_RICE
  end

  def rice_weight
    return drying_moths.sum(:rice_weight)
  end

  def harvest_weight(system)
    return rice_weight || 0 if country?
    return adjustment&.rice_weight(system) || 0
  end

  def waste_weight
    return 0 if country?
    return adjustment&.waste_weight || 0
  end

  def waste_date
    return adjustment&.waste_date if adjustment&.waste_date.present?
    return shipped_on
  end

  def adjust_only?(home_id)
    return another? && adjustment&.home_id == home_id
  end

  def delete_child
    if country?
      adjustment.destroy
    else
      drying_moths.destroy_all
    end
    self
  end

  def price(system, home_id)
    return system.adjust_price if adjust_only?(home_id)
    return self? ? system.dry_adjust_price : system.dry_price
  end

  def amount(system, home_id)
    (harvest_weight(system) / KG_PER_BAG_RICE * price(system, home_id)).floor(-2)
  end

  def waste_price(sys, home_id)
    return sys.waste_adjust_price if adjust_only?(home_id)
    return self? ? sys.waste_price : sys.waste_drying_price
  end

  def waste_amount(sys, home_id)
    waste_weight / KG_PER_BAG_WASTE * waste_price(sys, home_id)
  end

  def total_amount(system, home_id)
    amount(system, home_id) + waste_amount(system, home_id)
  end

  def self.calc_total(dryings, home, system)
    rice_totals = {
      adjust: 0.0,
      country: 0.0,
      self: 0.0
    }
    waste_totals = {
      adjust: 0.0,
      self: 0.0,
      another: 0.0
    }
    shipped_totals = {
      adjust: 0.0,
      country: 0.0,
      self: 0.0
    }
    dryings.each do |drying|
      if drying.adjust_only?(home.id)
        rice_totals[:adjust] += drying.adjustment.rice_weight(system) || 0
        waste_totals[:adjust] += drying.adjustment.waste_weight || 0
        shipped_totals[:adjust] += drying.harvest_weight(system)
      elsif drying.another?
        rice_totals[:country] += drying.adjustment.rice_weight(system) || 0
        waste_totals[:another] += drying.waste_weight || 0
        shipped_totals[:country] += drying.harvest_weight(system)
      elsif drying.self?
        rice_totals[:self] += drying.adjustment.rice_weight(system) || 0
        waste_totals[:self] += drying.adjustment.waste_weight || 0
        shipped_totals[:self] += drying.harvest_weight(system)
      else
        rice_totals[:country] += drying.drying_moths.sum(:rice_weight) || 0
        waste_totals[:another] += drying.waste_weight || 0
        shipped_totals[:country] += drying.harvest_weight(system)
      end
    end
    return rice_totals, waste_totals, shipped_totals
  end

  def copy
    Drying.create(
      carried_on: self.carried_on,
      term: self.term,
      home_id: self.home_id,
      copy_flag: Drying.where(carried_on: self.carried_on, home_id: self.home_id).maximum(:copy_flag) + 1
    )
  end

  def drying_type_name
    I18n.t("activerecord.enums.drying.drying_type_ids.#{self.drying_type_id}")
  end
end
