# == Schema Information
#
# Table name: cleaning_institutions(清掃施設)
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  cleaning_id(清掃ID)    :integer          not null
#  institution_id(施設ID) :integer          not null
#
# Indexes
#
#  cleaning_institutions_2nd  (cleaning_id,institution_id) UNIQUE
#

class CleaningInstitution < ApplicationRecord
  belongs_to :cleaning
  belongs_to :institution
end
