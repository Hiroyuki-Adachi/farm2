class WorkKind < ActiveRecord::Base
  acts_as_paranoid

  has_many :machine_kinds
  has_many :machines,-> {order("machines.display_order")}, through: :machine_kinds 

  has_many :chemical_kinds
  has_many :chemical_types, -> {order("chemical_types.display_order")}, through: :chemical_kinds
  
  has_many :work_kind_types
  has_many :work_types, through: :work_kind_types

  validates :name, presence: true
  validates :price, presence: true
  validates :display_order, presence: true

  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
  validates :display_order, numericality: {only_integer: true}, if: Proc.new{|x| x.display_order.present?}

  scope :usual, -> {where(other_flag: false).order(:display_order)}
end
