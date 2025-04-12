# == Schema Information
#
# Table name: work_verifications(日報検証)
#
#  id(日報検証)      :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  work_id(作業)     :integer
#  worker_id(作業者) :integer
#
# Indexes
#
#  index_work_verifications_on_work_id_and_worker_id  (work_id,worker_id) UNIQUE
#

class WorkVerification < ApplicationRecord
  belongs_to :work
  belongs_to :worker, -> {with_deleted}

  ENOUGH = 2

  def self.regist(work, worker)
    return if work.created_by == worker.id

    Rails.application.config.update_logger.info "verified:#{worker.name}"
    verification = WorkVerification.find_by(work_id: work.id, worker_id: worker.id)
    if verification
      verification.touch
      verification.save!
    elsif WorkVerification.where(work_id: work.id).count < ENOUGH
      WorkVerification.create(work_id: work.id, worker_id: worker.id)
    end
  end
end
