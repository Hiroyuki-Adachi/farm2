# == Schema Information
#
# Table name: plan_seedlings # 育苗計画
#
#  id                          :bigint           not null, primary key
#  quantity(枚数)              :decimal(4, )     default(0), not null
#  seed_bag1(種子(大袋))       :decimal(2, )     default(0), not null
#  seed_bag2(種子(小袋))       :decimal(2, )     default(0), not null
#  seeds(種子(kg))             :decimal(3, )     default(0), not null
#  soil_bag(育苗土(袋))        :decimal(4, )     default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  home_id(世帯)               :integer
#  plan_work_type_id(作業計画) :integer          not null
#
# Indexes
#
#  plan_seedlings_2nd  (plan_work_type_id,home_id) UNIQUE
#
class PlanSeedling < ApplicationRecord
end
