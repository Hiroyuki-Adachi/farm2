# == Schema Information
#
# Table name: chemical_kinds # 作業種別薬剤種別利用マスタ
#
#  id(作業種別薬剤種別利用マスタ) :integer          not null, primary key
#  chemical_type_id(薬剤種別)     :integer          not null
#  work_kind_id(作業種別)         :integer          not null
#
# Indexes
#
#  index_chemical_kinds_on_chemical_type_id_and_work_kind_id  (chemical_type_id,work_kind_id) UNIQUE
#
class ChemicalKind < ApplicationRecord
  belongs_to :chemical_type
  belongs_to :work_kind
end
