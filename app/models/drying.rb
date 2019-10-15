# == Schema Information
#
# Table name: dryings # 乾燥
#
#  id             :bigint           not null, primary key
#  term           :integer          not null              # 年度(期)
#  work_type_id   :integer                                # 作業分類
#  home_id        :integer          default(0), not null  # 担当世帯
#  drying_type_id :integer          default(0), not null  # 乾燥種別
#  carried_on     :date             not null              # 搬入日
#  shipped_on     :date                                   # 出荷日
#  water_content  :decimal(3, 1)                          # 水分
#  rice_weight    :decimal(5, 1)                          # 乾燥米(kg)
#  fixed_amount   :decimal(7, )                           # 確定額
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Drying < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  KG_PER_BAG_RICE = 30
  KG_PER_BAG_WASTE = 25

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  belongs_to :drying_type
  has_many   :drying_moths, {dependent: :destroy}
  has_many   :drying_lands, {dependent: :destroy}
  has_one    :adjustment,   {dependent: :destroy}

  before_save :save_rice_weight, :save_adjustment

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
      .order("work_types.display_order, dryings.carried_on, homes.drying_order, dryings.id")
  }

  def rice_bag
    return (rice_weight || 0) / KG_PER_BAG_RICE
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

  def save_rice_weight
    if drying_type == DryingType::COUNTRY
      self.rice_weight = drying_moths.sum(:rice_weight)
      self.water_content = drying_moths[0].water_content
    else
      drying_moths.destroy_all
    end
  end

  def price(system, home_id)
    return system.adjust_price if adjust_only?(home_id)
    return drying_type == DryingType::SELF ? system.dry_adjust_price : system.dry_price
  end

  def amount(system, home_id)
    shipped_weight(system) / KG_PER_BAG_RICE * price(system, home_id)
  end

  def save_adjustment
    case drying_type
    when DryingType::COUNTRY
      adjustment.destroy
    when DryingType::SELF
      self.rice_weight = nil
    else
      self.rice_weight = adjustment&.rice_weight(System.find_by(term: term))
    end
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
    dryings.each do |drying|
      if drying.adjust_only?(home.id)
        rice_totals[DryingType::ADJUST.id] += drying.adjustment.rice_weight(system) || 0
        waste_totals[DryingType::ADJUST.id] += drying.adjustment.waste_weight || 0
        next
      end
      if drying.drying_type == DryingType::SELF
        rice_totals[DryingType::SELF.id] += drying.adjustment.rice_weight(system) || 0
        waste_totals[DryingType::SELF.id] += drying.adjustment.waste_weight || 0
      else
        rice_totals[DryingType::COUNTRY.id] += drying.rice_weight || 0
      end
    end
    return rice_totals, waste_totals
  end
end
