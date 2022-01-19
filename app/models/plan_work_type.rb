# == Schema Information
#
# Table name: plan_work_types
#
#  id             :integer          not null, primary key
#  work_type_id   :integer          not null
#  area           :decimal(7, 2)    default("0.0"), not null
#  month          :integer          default("0"), not null
#  unit           :decimal(3, 1)    default("0.0"), not null
#  quantity       :decimal(5, )     default("0.0"), not null
#  between_stocks :decimal(2, )     default("0.0"), not null
#  seeds          :decimal(3, )     default("0.0"), not null
#  soils          :decimal(4, 2)    default("0.0"), not null
#  bag_weight1    :decimal(3, 1)    default("0.0"), not null
#  bag_weight2    :decimal(3, 1)    default("0.0"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  plan_work_types_2nd  (work_type_id) UNIQUE
#

class PlanWorkType < ApplicationRecord
  belongs_to :work_type, -> {with_deleted}

  scope :usual, -> {joins(:work_type).includes(:work_type).where.not(month: 0).order("plan_work_types.month, work_types.genre, work_types.display_order, plan_work_types.id")}

  def self.create_all(params)
    params.each do |work_type_id, param|
      plan_work_type = PlanWorkType.find_by(work_type_id: work_type_id)
      if plan_work_type.present?
        plan_work_type.update(param)
      else
        plan_work_type = PlanWorkType.create(param.merge(work_type_id: work_type_id))
      end
    end
    PlanWorkType.joins(:work_type).where("work_types.deleted_at IS NOT NULL").destroy_all
  end
end
