# == Schema Information
#
# Table name: broccoli_sizes
#
#  id(ブロッコリ階級マスタ) :integer          not null, primary key
#  display_name(表示名)     :string(10)       default(""), not null
#  display_order(表示順)    :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class BroccoliSize < ApplicationRecord
  scope :usual, -> {order("display_order")}
end
