# == Schema Information
#
# Table name: schedule_workers # 作業予定作業者
#
#  id            :integer          not null, primary key # 作業予定作業者
#  schedule_id   :integer                                # 作業予定
#  worker_id     :integer                                # 作業者
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ScheduleWorker < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :worker, -> { with_deleted }
  has_one    :home, { through: :worker }, -> { with_deleted }
  has_one    :work_type, { through: :schedule }, -> { with_deleted }
  has_one    :work_kind, { through: :schedule }, -> { with_deleted }
end
