# == Schema Information
#
# Table name: lands # 土地マスタ
#
#  id            :integer          not null, primary key
#  place         :string(15)       not null                # 番地
#  owner_id      :integer                                  # 所有者
#  manager_id    :integer                                  # 管理者
#  area          :decimal(5, 2)    not null                # 面積(α)
#  display_order :integer                                  # 表示順
#  target_flag   :boolean          default(TRUE), not null # 管理対象フラグ
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  land_place_id :integer                                  # 土地
#  reg_area      :decimal(5, 2)                            # 登記面積
#  broccoli_mark :string(1)                                # ブロッコリ記号
#

class Land < ApplicationRecord
  acts_as_paranoid

  belongs_to :owner, -> {with_deleted}, {class_name: :Home, foreign_key: :owner_id}
  belongs_to :manager, -> {with_deleted}, {class_name: :Home, foreign_key: :manager_id}
  belongs_to :land_place, -> {with_deleted}

  has_one :owner_holder, -> {with_deleted}, {through: :owner, source: :holder}
  has_one :manager_holder, -> {with_deleted}, {through: :manager, source: :holder}

  has_many :work_lands
  has_many :works, {through: :work_lands}

  has_many :land_costs, -> {order(:activated_on)}

  scope :usual, -> {where(target_flag: true).order("place, display_order")}
  scope :list, -> {includes(:land_place, :owner, :manager, :owner_holder, :manager_holder).order("place, lands.display_order, lands.id")}
  scope :for_finance1, -> {where("owner_id = manager_id").where(target_flag: true)}
  scope :for_finance2, -> {where("owner_id <> manager_id").where(target_flag: true)}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, if: proc { |x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  accepts_nested_attributes_for :land_costs, allow_destroy: true, reject_if: :reject_land_costs

  def owner_name
    owner.member_flag ? owner_holder.name : owner.name
  end

  def manager_name
    manager.member_flag ? manager_holder.name : manager.name
  end

  def place_name
    land_place ? land_place.name : ""
  end

  def self.autocomplete(place)
    results = []
    Land.where("target_flag = ? AND (place like ? OR area = ?)", true, "%#{place}%", place.to_f).order(:place, :display_order).limit(15).each do |land|
      results << {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land.owner.name, area: land.area}}
    end
    return results.to_json
  end

  def reject_land_costs(attributes)
    attributes[:activated_on].blank? || attributes[:work_type_id].blank?
  end

  def costs(start_date, end_date)
    results = {}
    tmp_date = start_date
    tmp_cost = land_costs.newest(start_date)&.first
    return 0, [] unless tmp_cost
    land_costs.where(["activated_on BETWEEN ? AND ?", start_date + 1, end_date]).order("land_costs.activated_on").each do |land_cost|
      results[tmp_cost.work_type_id] ||= 0
      results[tmp_cost.work_type_id] += (land_cost.activated_on - tmp_date)
      tmp_date = land_cost.activated_on
      tmp_cost = land_cost
    end
    results[tmp_cost.work_type_id] ||= 0
    results[tmp_cost.work_type_id] += (end_date - tmp_date + 1)

    return tmp_cost.cost, results
  end

  def land_display_order
    result = land_place.display_order * LandPlace.maximum(:id) + land_place_id
    result = (result * Land.maximum(:display_order) + display_order) * Land.maximum(:id) + id
    return result
  end

  def cost(target)
    LandCost.newest(target).find_by(land_id: id)
  end
end
