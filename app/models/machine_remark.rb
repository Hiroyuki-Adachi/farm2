# == Schema Information
#
# Table name: machine_remarks
#
#  id                         :bigint           not null, primary key
#  care_remarks(備考(保守))   :string(30)       default(""), not null
#  danger_remarks(備考(危険)) :string(30)       default(""), not null
#  other_remarks(備考)        :string(30)       default(""), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  machine_id(機械)           :integer          not null
#  work_id(作業)              :integer          not null
#
# Indexes
#
#  machine_remarks_2nd  (work_id,machine_id) UNIQUE
#
class MachineRemark < ApplicationRecord
  belongs_to  :machine, -> {with_deleted}
  belongs_to  :work

  def self.regist(work, remarks)
    work.machine_remarks.destroy_all
    remarks.each do |id, remark|
      if remark[:care_remarks].present? || remark[:danger_remarks].present? || remark[:other_remarks].present?
        MachineRemark.create(
          remark.permit(:work_id, :machine_id, :care_remarks, :danger_remarks, :other_remarks)
        )
      end
    end
  end

  def remarks
    return self.danger_remarks if self.danger_remarks.present?
    return self.care_remarks   if self.care_remarks.present?
    return self.other_remarks
  end
end
