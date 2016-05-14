class Chemical < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :chemical_type

  scope :usual, -> {includes(:chemical_type).order("chemical_types.display_order, chemicals.display_order, chemicals.id")}
end
