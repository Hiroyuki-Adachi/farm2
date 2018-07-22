# == Schema Information
#
# Table name: work_whole_crops # WCS作業
#
#  id         :bigint(8)        not null, primary key
#  work_id    :integer          not null              # 作業
#  rolls      :decimal(4, )     default(0), not null  # ロール数
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkWholeCrop < ApplicationRecord
  belongs_to :work

  scope :usual, ->(term) {joins(:work).where(["works.term = ?", term]).order("works.worked_at, works.id")}

  def self.regist(work, params)
    if work.whole_crop
      work.whole_crop.update(rolls: params[:rolls])
    else
      WorkWholeCrop.create(work_id: work.id, rolls: params[:rolls])
    end
  end
end
