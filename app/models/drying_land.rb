# == Schema Information
#
# Table name: drying_lands(乾燥調整場所)
#
#  id                    :bigint           not null, primary key
#  display_order(表示順) :integer          default(0), not null
#  percentage(割合)      :decimal(4, 1)    default(100.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  drying_id(乾燥調整)   :integer          default(0), not null
#  land_id(作業地)       :integer
#
# Indexes
#
#  drying_lands_3rd  (drying_id,display_order) UNIQUE
#

class DryingLand < ApplicationRecord
  belongs_to :drying
  belongs_to :land

  MAX_COUNT = 3

  scope :for_organization, lambda { |organization|
    joins(:drying).merge(Drying.for_organization(organization))
  }

  validate :land_belongs_to_drying_organization

  private

  def land_belongs_to_drying_organization
    return if land.blank? || drying&.home.blank?
    return if land.organization_id == drying.home.organization_id

    errors.add(:land_id, "は乾燥担当世帯と同じ組織の土地を指定してください。")
  end
end
