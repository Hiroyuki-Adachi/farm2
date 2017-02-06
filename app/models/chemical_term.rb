# == Schema Information
#
# Table name: chemical_terms # 薬剤年度別利用マスタ
#
#  chemical_id :integer          not null # 薬剤
#  term        :integer          not null # 年度(期)
#

class ChemicalTerm < ApplicationRecord
  belongs_to :chemical
end
