class Chemical < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :chemical_type

  named_scope :usual, lambda {|chemical_kinds| {:include => [:chemical_type], :order => "chemical_types.display_order, chemicals.display_order, chemicals.id", :conditions => chemical_kinds ? ["chemical_type_id IN (?)", chemical_kinds] : []}}
end
