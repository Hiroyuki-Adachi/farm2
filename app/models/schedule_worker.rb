# == Schema Information
#
# Table name: schedule_workers
#
#  id            :integer          not null, primary key
#  schedule_id   :integer
#  worker_id     :integer
#  display_order :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid          :string(36)
#
# Indexes
#
#  index_schedule_workers_on_schedule_id_and_worker_id  (schedule_id,worker_id) UNIQUE
#

require 'date'
require 'securerandom'
class ScheduleWorker < ApplicationRecord
  belongs_to :schedule
  belongs_to :worker, -> {with_deleted}
  has_one    :home, -> {with_deleted}, through: :worker
  has_one    :work_type, -> {with_deleted}, through: :schedule
  has_one    :work_kind, -> {with_deleted}, through: :schedule

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
