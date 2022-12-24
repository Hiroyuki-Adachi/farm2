# == Schema Information
#
# Table name: training_types
#
#  id                       :bigint           not null, primary key
#  display_order(表示順)    :integer          not null
#  name(名称)               :string(10)       not null
#  other_flag(その他フラグ) :boolean          default(FALSE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class TrainingType < ApplicationRecord
  scope :usual, -> { order(other_flag: :ASC, display_order: :ASC, id: :ASC) }
end
