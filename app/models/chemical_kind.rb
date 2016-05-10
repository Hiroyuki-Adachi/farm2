class ChemicalKind < ActiveRecord::Base
  belongs_to :chemical_type
  belongs_to :work_kind
end
