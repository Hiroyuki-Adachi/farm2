# == Schema Information
#
# Table name: depreciation_types # 減価償却分類
#
#  id(減価償却分類)          :integer          not null, primary key
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  depreciation_id(減価償却) :integer
#  work_type_id(作業分類)    :integer          not null
#
# Indexes
#
#  index_depreciation_types_on_depreciation_id_and_work_type_id  (depreciation_id,work_type_id) UNIQUE
#
class DepreciationType < ApplicationRecord
  belongs_to :depreciation
  belongs_to :work_type
end
