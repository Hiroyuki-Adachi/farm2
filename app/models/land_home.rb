# == Schema Information
#
# Table name: land_homes(土地管理)
#
#  id                         :bigint           not null, primary key
#  area(面積)                 :decimal(5, 2)    not null
#  manager_flag(管理者フラグ) :boolean
#  owner_flag(所有者フラグ)   :boolean
#  place(番地)                :string(15)       not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  home_id(世帯)              :integer
#  land_id(土地)              :integer          not null
#

class LandHome < ApplicationRecord
  belongs_to :home, -> { with_deleted }
  belongs_to :land

  validate :home_belongs_to_same_organization
  validate :home_has_land_flag

  private

  def home_belongs_to_same_organization
    return if land.blank? || home.blank? || land.organization_id == home.organization_id

    errors.add(:home_id, "は土地と同じ組織の世帯を選択してください。")
  end

  def home_has_land_flag
    return if home.blank? || home.land_flag?

    errors.add(:home_id, "は土地フラグが有効な世帯を指定してください。")
  end
end
