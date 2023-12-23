# == Schema Information
#
# Table name: work_work_types
#
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  work_id(作業)          :integer          not null, primary key
#  work_type_id(作業分類) :integer          not null, primary key
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
