# == Schema Information
#
# Table name: plan_work_types # 作業計画
#
#  id                       :bigint           not null, primary key
#  area(面積(α))            :decimal(7, 2)    default(0.0), not null
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
end
