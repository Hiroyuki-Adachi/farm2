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
end
