# == Schema Information
#
# Table name: chemical_terms
#
#  chemical_id :integer          not null
#  term        :integer          not null
#

class ChemicalTerm < ActiveRecord::Base
  belongs_to :chemical
end
