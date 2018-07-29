# == Schema Information
#
# Table name: minutes # 議事録
#
#  id          :bigint(8)        not null, primary key
#  schedule_id :integer          default(0), not null  # 作業予定
#  pdf_name    :string(50)                             # PDFファイル名
#  pdf         :binary                                 # PDF
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Minute < ApplicationRecord
  belongs_to :schedule

  scope :for_personal, ->(worker) {
    joins(:schedule).where([<<SQL, worker.id]).order("schedules.worked_at, minutes.id").select("minutes.id, minutes.schedule_id").last
    EXISTS (SELECT * FROM schedule_workers
      WHERE schedules.id = schedule_workers.schedule_id AND schedule_workers.worker_id = ?
    )
SQL
  }
end
