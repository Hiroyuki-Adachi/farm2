# == Schema Information
#
# Table name: depreciation_types # 減価償却分類
#
#  id              :integer          not null, primary key # 減価償却分類
#  depreciation_id :integer                                # 減価償却
#  work_type_id    :integer          not null              # 作業分類
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class DepreciationType < ApplicationRecord
  belongs_to :depreciation
  belongs_to :work_type
end
