# == Schema Information
#
# Table name: work_chemicals # 薬剤使用データ
#
#  id          :integer          not null, primary key  # 薬剤使用データ
#  work_id     :integer          not null               # 作業
#  chemical_id :integer          not null               # 薬剤
#  quantity    :decimal(5, 1)    default(0.0), not null # 使用量
#  created_at  :datetime
#  updated_at  :datetime
#

class WorkChemical < ApplicationRecord
  belongs_to :chemical
  belongs_to :work
  has_one    :chemical_type, { through: :chemical }, -> { with_deleted }
  has_one    :work_type, { through: :work }, -> { with_deleted }
  has_one    :work_kind, { through: :work }, -> { with_deleted }

  validates_presence_of :quantity
  validates_numericality_of :quantity, if: proc { |x| x.quantity.present? }

  scope :by_work, ->(term){
      joins(:work).eager_load(:work)
     .joins(:chemical).eager_load(:chemical)
     .joins("INNER JOIN chemical_types ON chemicals.chemical_type_id = chemical_types.id").preload(:chemical_type)
     .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
     .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
     .joins("INNER JOIN systems ON systems.term = works.term")
     .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
     .where("systems.term = ?", term)
     .order("works.worked_at, works.id, chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id")
  }
end
