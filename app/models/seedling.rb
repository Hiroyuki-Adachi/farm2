# == Schema Information
#
# Table name: seedlings # 育苗
#
#  id                :integer          not null, primary key # 育苗
#  term              :integer          not null              # 年度(期)
#  work_type_id      :integer                                # 作業分類
#  seedling_quantity :decimal(4, )     default(0), not null  # 苗箱数
#  soil_quantity     :decimal(4, )     default(0), not null  # 育苗土数
#  seed_cost         :decimal(6, )     default(0), not null  # 種子原価
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Seedling < ActiveRecord::Base
  belongs_to :work_type

  scope :usual, ->(term, work_types) {where(term: term, work_type_id: work_types.ids)}
end
