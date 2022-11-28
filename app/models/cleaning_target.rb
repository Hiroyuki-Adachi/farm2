# == Schema Information
#
# Table name: cleaning_targets
#
#  id                    :bigint           not null, primary key
#  display_order(表示順) :integer          default(0), not null
#  name(名称)            :string(10)       default(""), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class CleaningTarget < ApplicationRecord
  scope :usual, -> {order(display_order: :ASC)}
end
