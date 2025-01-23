# == Schema Information
#
# Table name: chemical_kinds
#
#  id               :integer          not null, primary key
#  chemical_type_id :integer          not null
#  work_kind_id     :integer          not null
#
# Indexes
#
#  index_chemical_kinds_on_chemical_type_id_and_work_kind_id  (chemical_type_id,work_kind_id) UNIQUE
#

class ChemicalKind < ApplicationRecord
  belongs_to :chemical_type
  belongs_to :work_kind
end
