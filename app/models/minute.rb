# == Schema Information
#
# Table name: minutes
#
#  id          :integer          not null, primary key
#  schedule_id :integer          default("0"), not null
#  pdf_name    :string(50)
#  pdf         :binary
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_minutes_on_schedule_id  (schedule_id) UNIQUE
#

class Minute < ApplicationRecord
  belongs_to :schedule

  scope :for_personal, ->(worker) {
    joins(:schedule).where([<<SQL, worker.id]).order("schedules.worked_at, minutes.id").select("minutes.id, minutes.schedule_id")
    EXISTS (SELECT * FROM schedule_workers
      WHERE schedules.id = schedule_workers.schedule_id AND schedule_workers.worker_id = ?
    )
SQL
  }

  def member?(worker)
    return schedule.workers.include?(worker)
  end
end
