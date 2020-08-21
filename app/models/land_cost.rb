# == Schema Information
#
# Table name: land_costs # 土地原価
#
#  id(土地原価)           :integer          not null, primary key
#  activated_on(有効日)   :date             default(Mon, 01 Jan 1900), not null
#  cost(原価)             :decimal(7, 1)    default(0.0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  land_id(土地)          :integer          not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  index_land_costs_on_activated_on_and_land_id  (activated_on,land_id) UNIQUE
#
class LandCost < ApplicationRecord
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> {with_deleted}

  validates :activated_on, presence: true
  validates :land_id, presence: true
  validates :work_type_id, presence: true
  validates :cost, presence: true

  scope :newest, ->(target) {where([<<SQL, target])}
  EXISTS (
    SELECT land_id, MAX(activated_on)
      FROM land_costs lc2
      WHERE lc2.land_id = land_costs.land_id AND activated_on <= ?
      GROUP BY land_id
      HAVING MAX(activated_on) = land_costs.activated_on
  )
SQL

  scope :usual, ->(lands, target) {newest(target).where(land_id: lands.ids)}
  scope :by_work_type, ->(work_type_id, target) {newest(target).where(work_type_id: work_type_id)}

  scope :total, ->(target) {joins(:land).newest(target).group(:work_type_id).sum("lands.area")}

  def self.sum_area_by_lands(target, land_ids)
    LandCost.newest(target).where(land_id: land_ids).group(:work_type_id).joins(:land).sum(:area)
  end

  def self.sum_area_by_work_type(target, work_type_id)
    LandCost.by_work_type(work_type_id, target).joins(:land).sum(:area)
  end

  def self.sum_area_for_harvest(worked_at, work_kind_id)
    results = {}
    Work.where(worked_at: worked_at, work_kind_id: work_kind_id).each do |work|
      work.lands.each do |land|
        land_cost = land.cost(worked_at)
        next if land_cost.nil?
        results[land_cost.work_type_id] = 0 unless results[land_cost.work_type_id]
        results[land_cost.work_type_id] += land.area
      end
    end

    return results
  end

  def update_work_type(params, start_date)
    return if work_type_id == params[:work_type_id].to_i && cost == params[:cost].to_i

    if activated_on < start_date
      land_cost = LandCost.new(params)
      land_cost.activated_on = start_date
      land_cost.save
    else
      update(params)
    end
  end
end
