# == Schema Information
#
# Table name: work_chemicals
#
#  id                :integer          not null, primary key
#  work_id           :integer          not null
#  chemical_id       :integer          not null
#  quantity          :decimal(5, 1)    default("0"), not null
#  created_at        :datetime
#  updated_at        :datetime
#  chemical_group_no :integer          default("1"), not null
#  area_flag         :boolean          default("false"), not null
#  magnification     :decimal(5, 1)
#  remarks           :text             default(""), not null
#  dilution_id       :integer          default("0"), not null
#
# Indexes
#
#  work_chemicals_2nd_key  (work_id,chemical_id,chemical_group_no) UNIQUE
#

class WorkChemical < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :chemical
  belongs_to :work
  belongs_to_active_hash :dilution
  has_one    :stock, dependent: :destroy, class_name: :ChemicalStock
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

  scope :for_stock, -> (chemical_id, start_date) {
    joins(:work)
    .includes(:chemical)
    .where("works.worked_at >= ? AND work_chemicals.chemical_id = ?", start_date, chemical_id)
    .order("works.worked_at, works.id")
  }

  def chemical_display_order
    chemical_type.display_order * 100_000 + chemical_type.id * 1000 + chemical.display_order * 100 + chemical_id
  end

  def quantity10
    sum_area = work.sum_areas
    return sum_area == 0 ? 0 : (quantity / sum_area * 10).round(1)
  end

  def dilution_amount
    return dilution? && chemical.unit_scale.positive? ? quantity * magnification / chemical.unit_scale : quantity
  end

  def dilution?
    return dilution.dilution
  end

  def dilution_none?
    return dilution == Dilution::NONE
  end

  def dilution_l?
    return dilution == Dilution::L
  end

  def dilution_mag?
    return dilution == Dilution::MAG
  end

  def quantity_for_stock
    return chemical.stock_quantity.zero? ? quantity : quantity * chemical.base_quantity / chemical.stock_quantity
  end
end
