# == Schema Information
#
# Table name: machine_remarks
#
#  id               :bigint           not null, primary key
#  remarks(備考)    :string(20)       default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  machine_id(機械) :integer          not null
#  work_id(作業)    :integer          not null
#
# Indexes
#
#  machine_remarks_2nd  (work_id,machine_id) UNIQUE
#
class MachineRemark < ApplicationRecord
  belongs_to  :machine, -> {with_deleted}
  belongs_to  :work
end
