# == Schema Information
#
# Table name: work_kind_types
#
#  id           :integer          not null, primary key
#  work_kind_id :integer
#  work_type_id :integer
#

class WorkKindType < ActiveRecord::Base
  belongs_to :work_kind
  belongs_to :work_type
end
