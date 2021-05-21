# == Schema Information
#
# Table name: work_chemicals
#
#  id(薬剤使用データ)                  :integer          not null, primary key
#  chemical_group_no(薬剤グループ番号) :integer          default(1), not null
#  quantity(使用量)                    :decimal(5, 1)    default(0.0), not null
#  created_at                          :datetime
#  updated_at                          :datetime
#  chemical_id(薬剤)                   :integer          not null
#  work_id(作業)                       :integer          not null
#
# Indexes
#
#  work_chemicals_2nd_key  (work_id,chemical_id,chemical_group_no) UNIQUE
#
class WorkChemical < ApplicationRecord
  belongs_to :chemical
  belongs_to :work
  has_one    :chemical_type, through: :chemical
  has_one    :work_type, -> {with_deleted}, through: :work
  has_one    :work_kind, -> {with_deleted}, through: :work

  validates_presence_of :quantity
  validates_numericality_of :quantity, if: proc { |x| x.quantity.present?}

  scope :by_term, ->(term){
    joins(:work)
      .eager_load(:work)
      .joins(:chemical).eager_load(:chemical)
      .joins("INNER JOIN chemical_types ON chemicals.chemical_type_id = chemical_types.id").preload(:chemical_type)
      .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
      .joins("INNER JOIN systems ON systems.term = works.term")
      .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
      .where("systems.term = ?", term)
      .order("works.worked_at, works.id, chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id")
  }

  def chemical_display_order
    chemical_type.display_order * 100_000 + chemical_type.id * 1000 + chemical.display_order * 100 + chemical_id
  end
end
