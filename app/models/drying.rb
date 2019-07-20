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

  KG_PER_BAG = 30

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  belongs_to :drying_type
  has_many   :drying_moths, {dependent: :destroy}
  has_many   :drying_lands, {dependent: :destroy}
  has_one    :adjustment,   {dependent: :destroy}

  accepts_nested_attributes_for :drying_moths
  accepts_nested_attributes_for :drying_lands
  accepts_nested_attributes_for :adjustment

  scope :by_home, ->(term, home) {
    left_joins(:adjustment)
      .where(["dryings.term = ? AND (dryings.home_id = ? OR adjustments.home_id = ?)", term, home.id, home.id])
      .order(:carried_on)
  }

  def rice_bag
    return (rice_weight || 0) / KG_PER_BAG
  end

  def adjust_only?(home_id)
    return drying_type == DryingType::ANOTHER && adjustment&.home_id == home_id
  end
end
