# == Schema Information
#
# Table name: cleaning_cleaning_targets(清掃対象)
#
#  id                 :integer          not null, primary key
#  cleaning_id        :integer
#  cleaning_target_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_cleaning_cleaning_targets_on_cleaning_id  (cleaning_id)
#

class CleaningCleaningTarget < ApplicationRecord
  belongs_to :cleaning
  belongs_to :cleaning_target
end
