# == Schema Information
#
# Table name: work_verifications # 日報検証
#
#  id         :integer          not null, primary key # 日報検証
#  work_id    :integer                                # 作業
#  worker_id  :integer                                # 作業者
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkVerification < ApplicationRecord
  belongs_to :work
  belongs_to :worker, -> { with_deleted }

  ENOUGH = 3

  def self.regist(work, worker)
    return if work.created_by == worker.id

    Rails.application.config.update_logger.info "updated by #{worker.name}"
    wv = WorkVerification.where(work_id: work.id, worker_id: worker.id)
    if wv.exists?
      wv.first.touch
      wv.first.save!
    else
      WorkVerification.create(work_id: work.id, worker_id: worker.id)
    end
  end
end
