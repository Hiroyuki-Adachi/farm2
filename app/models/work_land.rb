# == Schema Information
#
# Table name: work_lands(作業地データ)
#
#  id(作業地データ)                    :integer          not null, primary key
#  chemical_group_no(薬剤グループ番号) :integer          default(0), not null
#  display_order(表示順)               :integer          default(0), not null
#  fixed_cost(確定作業原価)            :decimal(6, )
#  created_at                          :datetime
#  updated_at                          :datetime
#  land_id(土地)                       :integer
#  work_id(作業)                       :integer
#  work_type_id(作業分類)              :integer
#
# Indexes
#
#  index_work_lands_on_work_id_and_land_id  (work_id,land_id) UNIQUE
#

class WorkLand < ApplicationRecord
  belongs_to :work
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> {with_deleted}
  has_one    :work_kind, -> {with_deleted}, through: :work
  has_one    :wcs_land, class_name: "WholeCropLand", dependent: :destroy

  scope :for_personal, ->(home, term) do
    joins(:work).includes(work: :work_kind)
      .joins(:land).includes(:land)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id")
      .where(works: { term: term })
      .where("(lands.manager_id = ? OR EXISTS (SELECT * FROM land_homes WHERE lands.id = land_homes.land_id AND home_id = ? AND manager_flag = true))", home.id, home.id)
      .order("lands.place_sort_key, lands.id, works.worked_at")
  end

  scope :for_fix, ->(term, fixed_at, contract_id) do
    joins(:work)
      .joins(:land)
      .where(works: { work_type_id: contract_id })
      .where("works.fixed_at = ? AND work_lands.fixed_cost IS NOT NULL", fixed_at)
      .where(works: { term: term })
  end

  scope :for_cards, ->(land_id, worked_at) do
    joins(:work).includes(:work)
      .joins(:land).includes(:land)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").includes(work: :work_kind)
      .where(works: { worked_at: worked_at.. })
      .where(lands: { id: land_id })
      .order("works.worked_at, works.id")
  end

  def interim_cost
    (work.sum_workers_amount * land.area / work.sum_areas).round
  end

  def largest?
    max_area = work.lands.map(&:area).max
    return false if land.area != max_area

    return land.id == work.lands.select { |land| land.area == max_area}.map(&:id).min
  end

  def cost
    return fixed_cost if fixed_cost
    local_cost = interim_cost
    return local_cost unless largest?
    return local_cost + (work.sum_workers_amount - work.work_lands.sum(&:interim_cost))
  end

  def self.by_worked_at(worked_at)
    lands = []
    Work.where(worked_at: worked_at).find_each do |work|
      lands << work.lands.to_a
    end
    return lands.flatten.uniq
  end

  def self.sum_areas(work_id, work_type_id, group = 0)
    if group.zero?
      WorkLand.joins(:land).where(work_id: work_id, work_type_id: work_type_id).sum("lands.area")
    else
      WorkLand.joins(:land).where(work_id: work_id, work_type_id: work_type_id, chemical_group_no: group).sum("lands.area")
    end
  end

  def same_areas
    return WorkLand.sum_areas(work_id, work_type_id, work.chemical_group_flag ? chemical_group_no : 0)
  end

  def total_areas
    WorkLand.joins(:land).where(work_id: work_id).sum("lands.area")
  end

  def total_sunshine(organization)
    rice_plant_work = Work.by_land(land).where(work_kind_id: organization.rice_planting_id, term: work.term).order(:worked_at, :id).first
    return nil unless rice_plant_work
    return nil if work.worked_at < rice_plant_work.worked_at 
    return DailyWeather.sum_sunshine(rice_plant_work.worked_at, work.worked_at)
  end

  def chemicals
    results = []
    work.work_chemicals.each do |work_chemical|
      next if chemical_group_no.positive? && work_chemical.chemical_group_no != chemical_group_no
      chemical_term = ChemicalTerm.find_by(chemical_id: work_chemical.chemical_id, term: work_chemical.work.term)
      next unless chemical_term
      chemical_work_type = ChemicalWorkType.find_by(chemical_term_id: chemical_term, work_type_id: work_type_id)
      next unless chemical_work_type&.quantity&.positive?
      denom = 0
      ChemicalWorkType.usable(chemical_term).each do |cw|
        denom += (WorkLand.sum_areas(work_id, cw.work_type_id) * cw.quantity)
      end
      next if denom.zero?
      results.push({
                     chemical: work_chemical.chemical,
                     quantity: work_chemical.quantity10,
                     standard: chemical_work_type.quantity
                   })
    end
    results.push({chemical: nil, quantity: nil}) if results.none?
    return results
  end

  def land_cost
    land.cost(work.worked_at)
  end

  def self.regist_chemical_group_no(params)
    params.each do |key, value|
      WorkLand.update(key, chemical_group_no: value)
    end
  end
end
