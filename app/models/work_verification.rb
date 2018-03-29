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

class WorkVerification < ActiveRecord::Base
  belongs_to :work
  belongs_to :worker, -> { with_deleted }

  before_create :destroy_for_create

  def destroy_for_create
    WorkVerification.destroy_all(work_id: work_id, worker_id: worker_id)
  end
end
