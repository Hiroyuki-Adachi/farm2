# == Schema Information
#
# Table name: broccoli_sizes
#
#  id            :integer          not null, primary key
#  display_name  :string(10)       default(""), not null
#  display_order :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BroccoliSize < ApplicationRecord
  scope :usual, -> {order("display_order")}
end
