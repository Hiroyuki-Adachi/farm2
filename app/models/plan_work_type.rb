# == Schema Information
#
# Table name: plan_work_types
#
#  id                       :bigint           not null, primary key
#  area(面積(α))            :decimal(7, 2)    default(0.0), not null
#  bag_weight1(大袋(kg))    :decimal(3, 1)    default(0.0), not null
#  bag_weight2(小袋(kg))    :decimal(3, 1)    default(0.0), not null
#  between_stocks(株間(cm)) :decimal(2, )     default(0), not null
#  month(開始月)            :integer          default(0), not null
#  quantity(枚数)           :decimal(5, )     default(0), not null
#  seeds(種子(1枚当g))      :decimal(3, )     default(0), not null
#  soils(育苗土(1枚当袋))   :decimal(4, 2)    default(0.0), not null
#  unit(枚数(10a当))        :decimal(3, 1)    default(0.0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  work_type_id(作業分類)   :integer          not null
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
        PlanWorkType.create(param.merge(work_type_id: work_type_id))
      end
    end
    PlanWorkType.joins(:work_type).where("work_types.deleted_at IS NOT NULL").destroy_all
  end
end
