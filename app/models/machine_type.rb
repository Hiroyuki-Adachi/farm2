class MachineType < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :display_order

end
