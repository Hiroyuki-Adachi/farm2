class MachineType < ActiveRecord::Base
  has_many :machines, dependent: :restrict_with_exception, -> {order("machines.display_order")}

  validates_presence_of :name
  validates_presence_of :display_order
end
