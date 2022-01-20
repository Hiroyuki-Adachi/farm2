# == Schema Information
#
# Table name: land_costs
#
#  id           :integer          not null, primary key
#  land_id      :integer          not null
#  work_type_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activated_on :date             default("1900-01-01"), not null
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

  def self.import_plans(base_date)
    LandCost.newest(base_date).each do |cost|
      plan = PlanLand.find_by(land_id: cost.land_id)
      if plan && plan.work_type_id != cost.work_type_id
        if cost.activated_on == base_date
          cost.update(work_type_id: plan.work_type_id)
        else
          LandCost.create(land_id: plan.land_id, work_type_id: plan.work_type_id, activated_on: base_date)
        end
      end
    end
  end

  def update_work_type(params, start_date)
    return if work_type_id == params[:work_type_id].to_i 

    if activated_on < start_date
      land_cost = LandCost.new(params)
      land_cost.activated_on = start_date
      land_cost.save
    else
      update(params)
    end
  end

  def next_land_cost
    LandCost.where("land_id = ? AND activated_on > ?", land_id, activated_on).order(activated_on: :asc).first
  end

  def regist_work_work_types
    Work.where("worked_at BETWEEN ? AND ?", activated_on, next_land_cost&.activated_on || Date.today).by_land(land).each do |w|
      w.regist_work_work_types
    end
  end
end
