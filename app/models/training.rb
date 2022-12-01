class Training < ApplicationRecord
  has_many :training_training_types, dependent: :destroy
  has_many :training_types, through: :training_training_types
end
