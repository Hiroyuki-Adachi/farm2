# == Schema Information
#
# Table name: dryings
#
#  id             :integer          not null, primary key
#  term           :integer          not null
#  work_type_id   :integer
#  home_id        :integer          default("0"), not null
#  drying_type_id :integer          default("0"), not null
#  carried_on     :date             not null
#  shipped_on     :date
#  water_content  :decimal(3, 1)
#  fixed_amount   :decimal(7, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  copy_flag      :integer          default("0"), not null
#
# Indexes
#
#  dryings_secondary  (carried_on,home_id,copy_flag) UNIQUE
#

class Drying < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  KG_PER_BAG_RICE = 30
  KG_PER_BAG_WASTE = 25

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  belongs_to_active_hash :drying_type
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

  def waste_weight
    return 0 if drying_type == DryingType::COUNTRY
    return adjustment&.waste_weight || 0
  end

  def waste_date
    return adjustment&.waste_date if adjustment&.waste_date.present?
    return shipped_on
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
    harvest_weight(system) / KG_PER_BAG_RICE * price(system, home_id)
  end

  def waste_amount(system)
    waste_weight / KG_PER_BAG_WASTE * system.waste_price
  end

  def total_amount(system, home_id)
    amount(system, home_id) + waste_amount(system)
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
        shipped_totals[DryingType::ADJUST.id] += drying.harvest_weight(system)
        next
      end
      if drying.drying_type == DryingType::SELF
        rice_totals[DryingType::SELF.id] += drying.adjustment.rice_weight(system) || 0
        waste_totals[DryingType::SELF.id] += drying.adjustment.waste_weight || 0
        shipped_totals[DryingType::SELF.id] += drying.harvest_weight(system)
      else
        rice_totals[DryingType::COUNTRY.id] += drying.drying_moths.sum(:rice_weight) || 0
        shipped_totals[DryingType::COUNTRY.id] += drying.harvest_weight(system)
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
end
