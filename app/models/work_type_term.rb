# == Schema Information
#
# Table name: work_type_terms
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  work_type_id :integer          not null
#  bg_color     :string(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  work_type_terms_2nd  (term,work_type_id) UNIQUE
#

class WorkTypeTerm < ApplicationRecord
  belongs_to :work_type, -> {with_deleted}
end
