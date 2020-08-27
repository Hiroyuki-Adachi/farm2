# == Schema Information
#
# Table name: work_work_types # 作業分類キャッシュ
#
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  work_id(作業)          :integer          not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  work_work_types_2nd  (work_id,work_type_id) UNIQUE
#
class WorkWorkType < ApplicationRecord
  belongs_to :work
  belongs_to :work_type
end
