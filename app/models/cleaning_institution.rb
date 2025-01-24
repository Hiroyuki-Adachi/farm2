# == Schema Information
#
# Table name: cleaning_institutions(清掃施設)
#
#  id             :integer          not null, primary key
#  cleaning_id    :integer          not null
#  institution_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  cleaning_institutions_2nd  (cleaning_id,institution_id) UNIQUE
#

class CleaningInstitution < ApplicationRecord
  belongs_to :cleaning
  belongs_to :institution
end
