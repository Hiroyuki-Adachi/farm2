class ChemicalType < ActiveRecord::Base
  has_many :chemicals, -> {order("chemicals.display_order")}, dependent: :restrict_with_exception

  has_many :chemical_kinds
  has_many :work_kinds,    through: :chemical_kinds
end
