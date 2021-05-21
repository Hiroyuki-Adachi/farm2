# == Schema Information
#
# Table name: dryings
#
#  id                       :bigint           not null, primary key
#  carried_on(搬入日)       :date             not null
#  fixed_amount(確定額)     :decimal(7, )
#  shipped_on(出荷日)       :date
#  term(年度(期))           :integer          not null
#  water_content(水分)      :decimal(3, 1)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  drying_type_id(乾燥種別) :integer          default(0), not null
#  home_id(担当世帯)        :integer          default(0), not null
#  work_type_id(作業分類)   :integer
#
# Indexes
#
#  dryings_secondary  (carried_on,home_id) UNIQUE
#
class Drying < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  KG_PER_BAG_RICE = 30
  KG_PER_BAG_WASTE = 25

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  belongs_to :drying_type
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
      .where(["dryings.term = ?", term])
      .order(Arel.sql("work_types.display_order, dryings.carried_on, homes.drying_order, dryings.id"))
  }

  def rice_bag
    return (rice_weight || 0) / KG_PER_BAG_RICE
  end

  def rice_weight
    return drying_moths.sum(:rice_weight)
  end

  def harvest_weight(system)
    return rice_weight || 0 if drying_type == DryingType::COUNTRY
    return adjustment&.rice_weight(system) || 0
  end

  def shipped_weight(system)
    harvest_weight(system) + (system.waste_sum_flag? ? (adjustment&.waste_weight || 0) : 0)
  end

  def adjust_only?(home_id)
    return drying_type == DryingType::ANOTHER && adjustment&.home_id == home_id
  end

  def delete_child
    if drying_type == DryingType::COUNTRY
      adjustment.destroy
    else
      drying_moths.destroy_all
    end
    self
  end

  def price(system, home_id)
    return system.adjust_price if adjust_only?(home_id)
    return drying_type == DryingType::SELF ? system.dry_adjust_price : system.dry_price
  end

  def amount(system, home_id)
    shipped_weight(system) / KG_PER_BAG_RICE * price(system, home_id)
  end

  def self.calc_total(dryings, home, system)
    rice_totals = {
      DryingType::ADJUST.id => 0.0,
      DryingType::COUNTRY.id => 0.0,
      DryingType::SELF.id => 0.0
    }
    waste_totals = {
      DryingType::ADJUST.id => 0.0,
      DryingType::SELF.id => 0.0
    }
    shipped_totals = {
      DryingType::ADJUST.id => 0.0,
      DryingType::COUNTRY.id => 0.0,
      DryingType::SELF.id => 0.0
    }
    dryings.each do |drying|
      if drying.adjust_only?(home.id)
        rice_totals[DryingType::ADJUST.id] += drying.adjustment.rice_weight(system) || 0
        waste_totals[DryingType::ADJUST.id] += drying.adjustment.waste_weight || 0
        shipped_totals[DryingType::ADJUST.id] += drying.shipped_weight(system)
        next
      end
      if drying.drying_type == DryingType::SELF
        rice_totals[DryingType::SELF.id] += drying.adjustment.rice_weight(system) || 0
        waste_totals[DryingType::SELF.id] += drying.adjustment.waste_weight || 0
        shipped_totals[DryingType::SELF.id] += drying.shipped_weight(system)
      else
        rice_totals[DryingType::COUNTRY.id] += drying.drying_moths.sum(:rice_weight) || 0
        shipped_totals[DryingType::COUNTRY.id] += drying.shipped_weight(system)
      end
    end
    return rice_totals, waste_totals, shipped_totals
  end
end
