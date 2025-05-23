# == Schema Information
#
# Table name: training_training_types(訓練訓練種別)
#
#  id                           :bigint           not null, primary key
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  training_id(訓練ID)          :integer          not null
#  training_type_id(訓練訓練ID) :integer          not null
#
# Indexes
#
#  training_training_types_2nd  (training_id,training_type_id) UNIQUE
#
class TrainingTrainingType < ApplicationRecord
  belongs_to :training_type
  belongs_to :training
end
