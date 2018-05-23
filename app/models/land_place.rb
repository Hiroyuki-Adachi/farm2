class LandPlace < ActiveRecord::Base
  acts_as_paranoid

  scope :usual, -> {order("display_order")}

  has_many :lands
end
