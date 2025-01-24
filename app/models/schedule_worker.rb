# == Schema Information
#
# Table name: schedule_workers(作業予定作業者)
#
#  id(作業予定作業者)       :integer          not null, primary key
#  display_order(表示順)    :integer          default(0), not null
#  uuid(UUID(カレンダー用)) :string(36)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  schedule_id(作業予定)    :integer
#  worker_id(作業者)        :integer
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
      .where(["schedules.worked_at BETWEEN ? AND ?", Time.zone.today, Time.zone.today + day])
      .where(worker_id: worker)
      .order("schedules.worked_at, schedule_workers.id")
  }

  scope :for_calendar, ->(worker) {
    joins(:schedule)
      .eager_load(:schedule)
      .joins("INNER JOIN work_kinds ON schedules.work_kind_id = work_kinds.id").preload(:work_kind)
      .where(["schedules.worked_at >= ? OR schedules.work_flag = ?", Time.zone.today, false])
      .where(worker_id: worker)
      .order("schedules.worked_at, schedule_workers.id")
  }

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
