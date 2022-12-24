# == Schema Information
#
# Table name: cleaning_cleaning_targets
#
#  id                             :bigint           not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cleaning_id(清掃)              :bigint
#  cleaning_target_id(清掃対象ID) :integer
#
# Indexes
#
#  index_cleaning_cleaning_targets_on_cleaning_id  (cleaning_id)
#
class CleaningCleaningTarget < ApplicationRecord
  belongs_to :cleaning
  belongs_to :cleaning_target
end
