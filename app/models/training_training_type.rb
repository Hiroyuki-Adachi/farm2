# == Schema Information
#
# Table name: training_training_types(訓練訓練種別)
#
#  id               :integer          not null, primary key
#  training_id      :integer          not null
#  training_type_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  training_training_types_2nd  (training_id,training_type_id) UNIQUE
#

class TrainingTrainingType < ApplicationRecord
  belongs_to :training_type
  belongs_to :training
end
