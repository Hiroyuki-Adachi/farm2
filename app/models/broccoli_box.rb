# == Schema Information
#
# Table name: broccoli_boxes
#
#  id            :integer          not null, primary key
#  weight        :decimal(3, 1)    default("0"), not null
#  display_name  :string(10)       default(""), not null
#  display_order :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BroccoliBox < ApplicationRecord
  scope :usual, -> {order("display_order")}
end
