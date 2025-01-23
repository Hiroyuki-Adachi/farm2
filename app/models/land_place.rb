# == Schema Information
#
# Table name: land_places
#
#  id            :integer          not null, primary key
#  name          :string(40)       not null
#  remarks       :text
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#

class LandPlace < ApplicationRecord
  acts_as_paranoid

  scope :usual, -> {order("display_order")}

  has_many :lands
end
