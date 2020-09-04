# == Schema Information
#
# Table name: work_lands # 作業地データ
#
#  id(作業地データ)         :integer          not null, primary key
#  display_order(表示順)    :integer          default(0), not null
#  fixed_cost(確定作業原価) :decimal(6, )
#  created_at               :datetime
#  updated_at               :datetime
#  land_id(土地)            :integer
#  work_id(作業)            :integer
#  work_type_id(作業分類)   :integer
#
# Indexes
#
#  index_work_lands_on_work_id_and_land_id  (work_id,land_id) UNIQUE
#
class WorkLand < ApplicationRecord
  belongs_to :work
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> {with_deleted}
  has_one    :work_kind, -> {with_deleted}, {through: :work}
  has_one    :wcs_land, {class_name: "WholeCropLand", dependent: :destroy}

  scope :for_personal, ->(home, worked_at) {
    joins(:work).eager_load(:work)
      .joins(:land).eager_load(:land)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
      .where("works.worked_at >= ?", worked_at)
      .where("lands.manager_id = ?", home.id)
      .order("lands.display_order, lands.id, works.worked_at")
  }

  scope :for_fix, ->(term, fixed_at, contract_id) {
    joins(:work)
      .joins(:land)
      .where("works.work_type_id = ?", contract_id)
      .where("works.fixed_at = ? AND work_lands.fixed_cost IS NOT NULL", fixed_at)
      .where("works.term = ?", term)
  }

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
    return local_cost + (work.sum_workers_amount - work.work_lands.map(&:interim_cost).sum)
  end

  def self.by_worked_at(worked_at)
    lands = []
    Work.where(worked_at: worked_at).find_each do |work|
      lands << work.lands.to_a
    end
    return lands.flatten.uniq
  end
end
