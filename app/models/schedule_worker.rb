require 'date'
require 'securerandom'
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
#  uuid          :string(36)                             # UUID(カレンダー用)
#

class ScheduleWorker < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :worker, -> { with_deleted }
  has_one    :home, { through: :worker }, -> { with_deleted }
  has_one    :work_type, { through: :schedule }, -> { with_deleted }
  has_one    :work_kind, { through: :schedule }, -> { with_deleted }

  before_create :set_uuid

  scope :for_personal, ->(worker, day) {
    joins(:schedule)
      .eager_load(:schedule)
      .joins("INNER JOIN work_kinds ON schedules.work_kind_id = work_kinds.id").preload(:work_kind)
      .where(["schedules.worked_at BETWEEN ? AND ?", Date.today, Date.today + day])
      .where(worker_id: worker)
      .order("schedules.worked_at, schedule_workers.id")
  }

  scope :for_calendar, ->(worker) {
    joins(:schedule)
      .eager_load(:schedule)
      .joins("INNER JOIN work_kinds ON schedules.work_kind_id = work_kinds.id").preload(:work_kind)
      .where(["schedules.worked_at >= ? OR schedules.work_flag = ?", Date.today, false])
      .where(worker_id: worker)
      .order("schedules.worked_at, schedule_workers.id")
  }

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
