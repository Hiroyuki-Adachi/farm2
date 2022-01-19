# == Schema Information
#
# Table name: lands
#
#  id            :integer          not null, primary key
#  place         :string(15)       not null
#  owner_id      :integer
#  manager_id    :integer
#  area          :decimal(5, 2)    not null
#  display_order :integer
#  target_flag   :boolean          default("true"), not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  land_place_id :integer
#  reg_area      :decimal(5, 2)
#  broccoli_mark :string(1)
#  region        :polygon
#  group_flag    :boolean          default("false"), not null
#  group_id      :integer
#  group_order   :integer          default("0"), not null
#  start_on      :date             default("1900-01-01"), not null
#  end_on        :date             default("2999-12-31"), not null
#
# Indexes
#
#  index_lands_on_deleted_at  (deleted_at)
#  index_lands_on_place       (place)
#

class Land < ApplicationRecord
  acts_as_paranoid

  belongs_to :owner, -> {with_deleted}, class_name: :Home, foreign_key: :owner_id
  belongs_to :manager, -> {with_deleted}, class_name: :Home, foreign_key: :manager_id
  belongs_to :land_place, -> {with_deleted}
  belongs_to :group, class_name: :Land, foreign_key: :group_id

  has_one :owner_holder, -> {with_deleted}, through: :owner, source: :holder
  has_one :manager_holder, -> {with_deleted}, through: :manager, source: :holder

  has_many :work_lands
  has_many :works, through: :work_lands
  has_many :land_costs, -> {order(:activated_on)}
  has_many :members, ->{order(:group_order, :display_order, :id)}, dependent: :nullify, foreign_key: :group_id, class_name: :Land
  has_many :land_fees
  has_many :plan_lands
  has_many :land_homes, dependent: :destroy

  scope :usual, -> {where(target_flag: true).order(:place, :display_order)}
  scope :list, -> {where(group_flag: false).includes(:group, :land_place, :owner, :manager, :owner_holder, :manager_holder).order(Arel.sql("place, lands.display_order, lands.id"))}
  scope :group_list, -> {where(group_flag: true).includes(:land_place, :members).order(Arel.sql("place, lands.display_order, lands.id"))}
  scope :for_finance1, -> {where("owner_id = manager_id").where(target_flag: true)}
  scope :for_finance2, -> {where("owner_id <> manager_id").where(target_flag: true)}
  scope :regionable, -> {where.not(region: nil).where(target_flag: true, group_id: nil)}
  scope :expiry, -> (target) {where("? BETWEEN start_on AND end_on", target)}
  scope :for_place, -> (place) {where("target_flag = TRUE AND group_id IS NULL AND (place like ? OR area = ?)", "%#{place}%", place.to_f).order(:place, :display_order)}

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, if: proc { |x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  accepts_nested_attributes_for :land_costs, allow_destroy: true, reject_if: :reject_land_costs
  accepts_nested_attributes_for :land_homes, allow_destroy: true

  def owner_name
    owner.member_flag ? owner_holder.name : owner.name
  end

  def self.for_plan(user_id)
    self.regionable
    .joins("LEFT OUTER JOIN plan_lands ON plan_lands.land_id = lands.id AND plan_lands.user_id = #{user_id}")
    .select("lands.*, plan_lands.work_type_id")
  end

  def manager_name
    manager.member_flag ? manager_holder.name : manager.name
  end

  def place_name
    land_place ? land_place.name : ""
  end

  def self.to_autocomplete(search_results)
    results = []
    search_results.limit(15).each do |land|
      results << {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land&.owner&.name || "", area: land.area}}
    end
    return results.to_json
  end

  def self.autocomplete_groups(place)
    results = []
    Land.where("target_flag = TRUE AND group_flag = FALSE AND (place like ?)", "%#{place}%").order(:place, :display_order).limit(15).each do |land|
      results << {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land&.owner&.name || "", area: land.area}}
    end
    return results.to_json
  end

  def reject_land_costs(attributes)
    attributes[:activated_on].blank? || attributes[:work_type_id].blank?
  end

  def plan_land(user_id)
    return self.plan_lands.find_by(user_id: user_id)
  end

  def costs(start_date, end_date)
    results = {}
    tmp_date = start_date
    tmp_cost = land_costs.newest(start_date)&.first
    return nil, [] unless tmp_cost
    land_costs.where(["activated_on BETWEEN ? AND ?", start_date + 1, end_date]).order("land_costs.activated_on").each do |land_cost|
      results[tmp_cost.work_type_id] ||= 0
      results[tmp_cost.work_type_id] += (land_cost.activated_on - tmp_date)
      tmp_date = land_cost.activated_on
      tmp_cost = land_cost
    end
    results[tmp_cost.work_type_id] ||= 0
    results[tmp_cost.work_type_id] += (end_date - tmp_date + 1)

    return land_fee(start_date.year), results
  end

  def land_display_order
    result = land_place.display_order * LandPlace.maximum(:id) + land_place_id
    result = (result * Land.maximum(:display_order) + display_order) * Land.maximum(:id) + id
    return result
  end

  def cost(target)
    LandCost.newest(target).find_by(land_id: id)
  end

  def region_values
    return nil if region.empty?
    return JSON.parse(region.gsub(/\(/, "[").gsub(/\)/, "]"))
  end

  def region_center
    max_v = [-180, -180]
    min_v = [180, 180]
    region_values.each do |rv|
      max_v[0] = rv[0] if max_v[0] < rv[0]
      max_v[1] = rv[1] if max_v[1] < rv[1]
      min_v[0] = rv[0] if min_v[0] > rv[0]
      min_v[1] = rv[1] if min_v[1] > rv[1]
    end
    return [(max_v[0] + min_v[0]) / 2, (max_v[1] + min_v[1]) / 2]
  end

  def region=(value)
    super(value == "" ? nil : value)
  end

  def self.update_members(land_id, members)
    Land.where(group_id: land_id, group_flag: false).update(group_id: nil, group_order: 0)
    return unless members
    members.each do |member|
      Land.where(id: member[:land_id]).update(group_id: land_id, group_order: member[:display_order])
    end
  end

  def land_fee(term)
    LandFee.find_by(term: term, land_id: self.id)
  end

  def expiry?(date = Date.today)
    self.start_on <= date && date <= self.end_on
  end
end
