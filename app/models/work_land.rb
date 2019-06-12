# == Schema Information
#
# Table name: work_lands # 作業地データ
#
#  id            :integer          not null, primary key # 作業地データ
#  work_id       :integer                                # 作業
#  land_id       :integer                                # 土地
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime
#  updated_at    :datetime
#

class WorkLand < ApplicationRecord
  belongs_to :work
  belongs_to :land, -> {with_deleted}
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

  def interim_cost
    (work.sum_workers_amount * land.area / work.sum_areas).round
  end

  def largest?
    max_area = work.lands.map(&:area).max
    return false if land.area != max_area

    return land.id == work.lands.select { |land| land.area == max_area}.map(&:id).min
  end

  def cost
    local_cost = interim_cost
    return local_cost unless largest?
    return local_cost + (work.sum_workers_amount - work.work_lands.map(&:interim_cost).sum)
  end
end
