# == Schema Information
#
# Table name: lands(土地マスタ)
#
#  id(土地マスタ)                     :integer          not null, primary key
#  area(面積(α))                      :decimal(5, 2)    not null
#  broccoli_mark(ブロッコリ記号)      :string(1)
#  deleted_at                         :datetime
#  display_order(表示順)              :integer
#  end_on(有効期間(至))               :date             default(Tue, 31 Dec 2999), not null
#  group_flag(グループフラグ)         :boolean          default(FALSE), not null
#  group_order(グループ内並び順)      :integer          default(0), not null
#  parcel_number(耕地番号)            :integer
#  peasant_end_term(小作料期間(至))   :integer          default(9999), not null
#  peasant_start_term(小作料期間(自)) :integer          default(0), not null
#  place(番地)                        :string(15)       not null
#  reg_area(登記面積)                 :decimal(5, 2)
#  region(領域)                       :polygon
#  start_on(有効期間(自))             :date             default(Mon, 01 Jan 1900), not null
#  target_flag(管理対象フラグ)        :boolean          default(TRUE), not null
#  uuid(UUID)                         :string(36)       default(""), not null
#  created_at                         :datetime
#  updated_at                         :datetime
#  group_id(グループID)               :integer
#  land_place_id(土地)                :integer
#  manager_id(管理者)                 :integer
#  owner_id(所有者)                   :integer
#
# Indexes
#
#  index_lands_on_deleted_at  (deleted_at)
#  index_lands_on_place       (place)
#  index_lands_on_uuid        (uuid) UNIQUE WHERE ((uuid)::text <> ''::text)
#

class Land < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at

  before_create :set_uuid

  belongs_to :owner, -> {with_discarded}, class_name: 'Home', foreign_key: :owner_id
  belongs_to :manager, -> {with_discarded}, class_name: 'Home', foreign_key: :manager_id
  belongs_to :land_place, -> {with_discarded}
  belongs_to :group, class_name: 'Land'

  has_one :owner_holder, -> {with_discarded}, through: :owner, source: :holder
  has_one :manager_holder, -> {with_discarded}, through: :manager, source: :holder

  has_many :work_lands
  has_many :works, through: :work_lands
  has_many :land_costs, -> {order(:activated_on)}
  has_many :members, ->{order(:group_order, :display_order, :id)}, dependent: :nullify, foreign_key: :group_id, class_name: :Land
  has_many :land_fees
  has_many :plan_lands
  has_many :land_homes, dependent: :destroy

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :usual, -> {kept.where(target_flag: true).order(:place, :display_order)}
  scope :list, -> {kept.where(group_flag: false).includes(:group, :land_place, :owner, :manager, :owner_holder, :manager_holder).order(Arel.sql("place, lands.display_order, lands.id"))}
  scope :group_list, -> {kept.where(group_flag: true).includes(:land_place, :members).order(Arel.sql("place, lands.display_order, lands.id"))}
  scope :for_finance1, -> {kept.where("owner_id = manager_id").where(target_flag: true)}
  scope :for_finance2, -> {kept.where("owner_id <> manager_id").where(target_flag: true)}
  scope :regionable, -> {kept.where.not(region: nil).where(target_flag: true, group_id: nil)}
  scope :for_place, ->(place) {kept.where("target_flag = TRUE AND group_id IS NULL AND (place like ? OR area = ?)", "%#{place}%", place.to_f).order(:place, :display_order)}
  scope :by_term, ->(sys) {kept.where(["start_on <= ? AND ? <= end_on", sys.end_date, sys.start_date])}
  scope :expiry, ->(target = nil) do
    target ||= Date.current

    kept.where(arel_table[:start_on].lteq(target))
      .where(arel_table[:end_on].gteq(target))
  end
  scope :for_personal, ->(home) do
    lands = arel_table
    land_homes = LandHome.arel_table

    exists_land_homes = Arel::Nodes::Exists.new(
      land_homes.project(Arel.sql('1')).where(
        land_homes[:land_id].eq(lands[:id])
          .and(land_homes[:home_id].eq(home.id))
      )
    )

    is_manager = lands[:manager_id].eq(home.id)
    is_owner = lands[:owner_id].eq(home.id)

    kept.where(
      is_manager.or(is_owner).or(exists_land_homes)
    )
  end

  validates :place, presence: true
  validates :area, presence: true
  validates :display_order, presence: true

  validates :area, numericality: true, if: proc { |x| x.area.present?}
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}
  validates :parcel_number, numericality: {only_integer: true}, allow_nil: true
  validates :peasant_start_term, numericality: {only_integer: true}, allow_nil: true
  validates :peasant_end_term, numericality: {only_integer: true}, allow_nil: true

  accepts_nested_attributes_for :work_lands, allow_destroy: true
  accepts_nested_attributes_for :land_fees, allow_destroy: true
  accepts_nested_attributes_for :plan_lands, allow_destroy: true
  accepts_nested_attributes_for :land_costs, allow_destroy: true, reject_if: :reject_land_costs
  accepts_nested_attributes_for :land_homes, allow_destroy: true

  def owner_name
    owner.member_flag ? owner_holder.name : owner.name
  end

  def self.for_plan(user_id, term)
    self.regionable
    .joins("LEFT OUTER JOIN plan_lands ON plan_lands.land_id = lands.id AND plan_lands.user_id = #{user_id} AND plan_lands.term = #{term}")
    .select("lands.*, plan_lands.work_type_id")
  end

  def manager_name
    manager.member_flag ? manager_holder.name : manager.name
  end

  def place_name
    land_place ? land_place.name : ""
  end

  def self.to_autocomplete(search_results)
    return search_results.map do |land|
      {id: land.id, place: land.place, owner: land&.owner&.name || "", area: land.area}
    end.to_json
  end

  def self.autocomplete_groups(place)
    results = Land.where("target_flag = TRUE AND group_flag = FALSE AND (place like ?)", "%#{place}%").order(:place, :display_order).limit(15).map do |land|
      {label: land.place + "(#{land.area})", value: land.id, details: {place: land.place, id: land.id, owner: land&.owner&.name || "", area: land.area}}
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
    result = (land_place.display_order * LandPlace.maximum(:id)) + land_place_id
    result = (((result * Land.maximum(:display_order)) + display_order) * Land.maximum(:id)) + id
    return result
  end

  def cost(target)
    LandCost.newest(target).find_by(land_id: id)
  end

  def region_values
    return nil if region.empty?
    return JSON.parse(region.tr('(', "[").tr(')', "]"))
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

  def expiry?(date = Time.zone.today)
    date.between?(self.start_on, self.end_on)
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
