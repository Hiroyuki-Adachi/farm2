# == Schema Information
#
# Table name: land_places(場所マスタ)
#
#  id(場所マスタ)        :integer          not null, primary key
#  deleted_at            :datetime
#  display_order(表示順) :integer
#  name(場所名称)        :string(40)       not null
#  remarks(備考)         :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class LandPlace < ApplicationRecord
  acts_as_paranoid

  scope :usual, -> {order("display_order")}

  has_many :lands
end
