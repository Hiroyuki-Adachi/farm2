# == Schema Information
#
# Table name: trainings
#
#  id                        :bigint           not null, primary key
#  content(内容)             :string(20)       default(""), not null
#  document(資料)            :string(40)       default(""), not null
#  place(場所)               :string(20)       default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  schedule_id(訓練ID)       :integer          not null
#  work_id(作業ID)           :integer          not null
#  worker_id(講師(作業者ID)) :integer          not null
#
class Training < ApplicationRecord
  has_many :training_training_types, dependent: :destroy
  has_many :training_types, through: :training_training_types

  belongs_to :work
  belongs_to :teacher, class_name: "Worker", foreign_key: 'worker_id'
  belongs_to :study, class_name: "Schedule", foreign_key: 'schedule_id'

  def studied_on
    self.study&.worked_at
  end

  def studied?
    !self.worker_id.nil?
  end
end
