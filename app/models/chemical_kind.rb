# == Schema Information
#
# Table name: chemical_kinds
#
#  id               :integer          not null, primary key
#  chemical_type_id :integer          not null
#  work_kind_id     :integer          not null
#

class ChemicalKind < ActiveRecord::Base
  belongs_to :chemical_type
  belongs_to :work_kind
end
