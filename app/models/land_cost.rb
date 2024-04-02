# == Schema Information
#
# Table name: land_costs
#
#  id(土地原価)           :integer          not null, primary key
#  activated_on(有効日)   :date             default(Mon, 01 Jan 1900), not null
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
    LandCost.by_work_type(work_type_id, target)
    .joins(:land)
    .where("lands.deleted_at IS NULL AND target_flag = true")
    .where("? BETWEEN lands.start_on AND lands.end_on", target)
    .sum(:area)
  end

  def self.sum_area_for_harvest(worked_at, work_kind_id)
    results = {}
    Work.where(worked_at: worked_at, work_kind_id: work_kind_id).find_each do |work|
      work.lands.each do |land|
        land_cost = land.cost(worked_at)
        next if land_cost.nil?
        results[land_cost.work_type_id] = 0 unless results[land_cost.work_type_id]
        results[land_cost.work_type_id] += land.area
      end
    end

    return results
  end

  def self.for_straws(term, work_type_id)
    LandCost.newest(Date.new(term.to_i, 4, 1)).joins(:land).where([<<SQL, work_type_id, term]).group("land_costs.work_type_id").sum("lands.area")
      EXISTS (SELECT * FROM work_lands 
        INNER JOIN works ON works.id = work_lands.work_id AND works.work_type_id = ? AND works.term = ?
        WHERE lands.id = work_lands.land_id
      )
SQL
  end

  def self.all_sum_area_by_work_type(sys)
    work_types = WorkType.by_term(sys.term).land
    results = []
    header = []
    header << ""
    work_types.each do |work_type|
      header << work_type.name
    end
    results << header
    (sys.start_date..sys.end_date).each do |day|
      result = []
      result << day
      work_types.each do |work_type|
        result << sum_area_by_work_type(day, work_type.id)
      end
      results << result
    end
    return results
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
    Work.where("worked_at BETWEEN ? AND ?", activated_on, next_land_cost&.activated_on || Time.zone.today).by_land(land).each do |w|
      w.regist_work_work_types
    end
  end
end
