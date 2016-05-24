class MachineType < ActiveRecord::Base
  has_many :machines, -> {order("machines.display_order, machines.id")}, dependent: :restrict_with_exception 

  has_many :machine_kinds
  has_many :work_kinds, -> {order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")}, {through: :machine_kinds, dependent: :destroy}

  validates :name, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}
end
