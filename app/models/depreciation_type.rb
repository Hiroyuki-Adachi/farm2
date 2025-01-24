# == Schema Information
#
# Table name: depreciation_types(減価償却分類)
#
#  id              :integer          not null, primary key
#  depreciation_id :integer
#  work_type_id    :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_depreciation_types_on_depreciation_id_and_work_type_id  (depreciation_id,work_type_id) UNIQUE
#

class DepreciationType < ApplicationRecord
  belongs_to :depreciation
  belongs_to :work_type
end
