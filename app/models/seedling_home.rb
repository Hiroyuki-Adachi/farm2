# == Schema Information
#
# Table name: seedling_homes # 育苗担当世帯
#
#  id          :integer          not null, primary key # 育苗担当世帯
#  seedling_id :integer                                # 育苗
#  home_id     :integer                                # 世帯
#  quantity    :decimal(4, )     default(0), not null  # 苗箱数
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SeedlingHome < ActiveRecord::Base
  belongs_to :home
  belongs_to :seedling

  scope :total, ->(seedlings){where(seedling_id: seedlings.ids).group(:seedling_id).sum(:quantity)}
end
