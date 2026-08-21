# == Schema Information
#
# Table name: minutes(議事録)
#
#  id                      :bigint           not null, primary key
#  pdf(PDF)                :binary
#  pdf_name(PDFファイル名) :string(50)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  schedule_id(作業予定)   :integer          default(0), not null
#
# Indexes
#
#  index_minutes_on_schedule_id  (schedule_id) UNIQUE
#

class Minute < ApplicationRecord
  belongs_to :schedule

  scope :for_organization, lambda { |organization|
    joins(:schedule).merge(Schedule.for_organization(organization))
  }

  scope :for_personal, lambda { |worker|
    for_organization(worker.organization_id)
      .where(
        [<<~SQL.squish, worker.id]
          EXISTS (SELECT * FROM schedule_workers
            WHERE schedules.id = schedule_workers.schedule_id AND schedule_workers.worker_id = ?
          )
        SQL
      )
      .order("schedules.worked_at, minutes.id").select("minutes.id, minutes.schedule_id")
  }

  def member?(worker)
    schedule.workers.include?(worker)
  end
end
