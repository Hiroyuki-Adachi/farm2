class System < ActiveRecord::Base
  validates_presence_of :term
  validates_presence_of :target_from
  validates_presence_of :target_to

  validates_numericality_of :term, :only_integer => true,
      :greater_than_or_equal_to => 2001, :less_than_or_equal_to => 2099

end
