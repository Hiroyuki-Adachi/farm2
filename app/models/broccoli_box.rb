# == Schema Information
#
# Table name: broccoli_boxes # ブロッコリ箱マスタ
#
#  id(ブロッコリ箱マスタ) :integer          not null, primary key
#  display_name(表示名)   :string(10)       default(""), not null
#  display_order(表示順)  :integer          default(0), not null
#  weight(重さ(kg))       :decimal(3, 1)    default(0.0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class BroccoliBox < ApplicationRecord
  scope :usual, -> {order("display_order")}
end
