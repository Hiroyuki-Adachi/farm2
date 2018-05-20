# == Schema Information
#
# Table name: lands # 土地マスタ
#
#  id            :integer          not null, primary key   # 土地マスタ
#  place         :string(15)       not null                # 番地
#  owner_id      :integer                                  # 所有者
#  manager_id    :integer                                  # 管理者
#  area          :decimal(5, 2)    not null                # 面積(α)
#  display_order :integer                                  # 表示順
#  target_flag   :boolean          default(TRUE), not null # 管理対象フラグ
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

class Land < ApplicationRecord
  acts_as_paranoid

  belongs_to :owner, -> {with_deleted}, {class_name: :Home, foreign_key: :owner_id}
  belongs_to :manager, -> {with_deleted}, {class_name: :Home, foreign_key: :manager_id}

  has_one :owner_holder, -> {with_deleted}, {through: :owner, source: :holder}
  has_one :manager_holder, -> {with_deleted}, {through: :manager, source: :holder}

  has_many :work_lands
  has_many :works, {through: :work_lands}

  has_many :land_uses
  has_many :work_types, {through: :land_uses}

  scope :usual, -> {where(target_flag: true).order("place, display_order")}
  scope :list, -> {includes(:owner, :owner_holder).order("place, lands.display_order, lands.id")}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, if: proc { |x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  def owner_name
    return owner.member_flag ? owner_holder.name : owner.name
  end

  def manager_name
    return manager.member_flag ? manager_holder.name : manager.name
  end

  def self.autocomplete(place)
    results = []
    Land.where("target_flag = ? AND (place like ? OR area = ?)", true, "%#{place}%", place.to_f).order(:place, :display_order).limit(15).each do |land|
      results << {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land.owner.name, area: land.area}}
    end
    return results.to_json
  end
end
