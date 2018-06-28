# == Schema Information
#
# Table name: seedling_results # 育苗結果
#
#  id               :integer          not null, primary key # 育苗結果
#  seedling_home_id :integer                                # 育苗担当
#  work_result_id   :integer                                # 作業結果
#  display_order    :integer          default(0), not null  # 表示順
#  quantity         :decimal(3, )     default(0), not null  # 苗箱数
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SeedlingResult < ActiveRecord::Base
end
