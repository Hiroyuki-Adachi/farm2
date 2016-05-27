# == Schema Information
#
# Table name: chemical_terms
#
#  id          :integer          not null, primary key
#  chemical_id :integer
#  term        :integer
#

class ChemicalTerm < ActiveRecord::Base
  belongs_to :chemical
end
