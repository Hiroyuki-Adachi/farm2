# == Schema Information
#
# Table name: chemical_kinds # 作業種別薬剤種別利用マスタ
#
#  id               :integer          not null, primary key # 作業種別薬剤種別利用マスタ
#  chemical_type_id :integer          not null              # 薬剤種別
#  work_kind_id     :integer          not null              # 作業種別
#

class ChemicalKind < ApplicationRecord
  belongs_to :chemical_type
  belongs_to :work_kind
end
