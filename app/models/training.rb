# == Schema Information
#
# Table name: trainings(訓練)
#
#  id                        :bigint           not null, primary key
#  content(内容)             :string(20)       default(""), not null
#  document(資料)            :string(40)       default(""), not null
#  remarks(備考)             :text             default(""), not null
#  studying_place(学習場所)  :string(20)       default(""), not null
#  training_place(研修場所)  :string(20)       default(""), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  schedule_id(訓練ID)       :integer
#  work_id(作業ID)           :integer          not null
#  worker_id(講師(作業者ID)) :integer
#
class Training < ApplicationRecord
  has_many :training_training_types, dependent: :destroy
  has_many :training_types, through: :training_training_types

  belongs_to :work
  belongs_to :teacher, class_name: "Worker", foreign_key: 'worker_id'
  belongs_to :study, class_name: "Schedule", foreign_key: 'schedule_id'

  scope :for_organization, lambda { |organization|
    joins(:work).merge(Work.for_organization(organization))
  }

  validate :teacher_belongs_to_work_organization
  validate :study_belongs_to_work_organization

  def studied_on
    study&.worked_at
  end

  def studied?
    !worker_id.nil?
  end

  private

  def teacher_belongs_to_work_organization
    return if work.blank? || teacher.blank? || teacher.organization_id == work.organization_id

    errors.add(:worker_id, "は作業と同じ組織の作業者を指定してください。")
  end

  def study_belongs_to_work_organization
    return if work.blank? || study.blank? || study.organization_id == work.organization_id

    errors.add(:schedule_id, "は作業と同じ組織の予定を指定してください。")
  end
end
