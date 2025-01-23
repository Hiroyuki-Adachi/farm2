# == Schema Information
#
# Table name: work_work_types
#
#  work_id      :integer          not null, primary key
#  work_type_id :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  work_work_types_2nd  (work_id,work_type_id) UNIQUE
#

class WorkWorkType < ApplicationRecord
  self.primary_key = [:work_id, :work_type_id]

  belongs_to :work
  belongs_to :work_type
end
