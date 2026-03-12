# == Schema Information
#
# Table name: work_chemicals(薬剤使用データ)
#
#  id(薬剤使用データ)                  :integer          not null, primary key
#  area_flag(10a当たり入力)            :boolean          default(FALSE), not null
#  chemical_group_no(薬剤グループ番号) :integer          default(1), not null
#  magnification(水溶液(リットル))     :decimal(5, 1)
#  quantity(使用量)                    :decimal(5, 1)    default(0.0), not null
#  remarks(備考)                       :text             default(""), not null
#  created_at                          :datetime
#  updated_at                          :datetime
#  chemical_id(薬剤)                   :integer          not null
#  dilution_id(希釈)                   :integer          default(0), not null
#  work_id(作業)                       :integer          not null
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
  has_one    :stock, dependent: :destroy, class_name: 'ChemicalStock'
  has_one    :chemical_type, through: :chemical
  has_one    :work_type, -> {with_deleted}, through: :work
  has_one    :work_kind, -> {with_deleted}, through: :work

  validates :quantity, presence: true
  validates :quantity, numericality: { if: proc { |x| x.quantity.present?} }

  scope :by_term, ->(term) do
    joins(:work)
      .eager_load(:work)
      .joins(:chemical).eager_load(:chemical)
      .joins("INNER JOIN chemical_types ON chemicals.chemical_type_id = chemical_types.id").preload(:chemical_type)
      .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
      .joins("INNER JOIN systems ON systems.term = works.term")
      .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
      .where(systems: { term: term })
      .order("works.worked_at, works.id, chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id")
  end

  scope :for_stock, ->(chemical_id, start_date) do
    joins(:work)
    .includes(:chemical)
    .where("works.worked_at >= ? AND work_chemicals.chemical_id = ?", start_date, chemical_id)
    .order("works.worked_at, works.id")
  end

  def chemical_display_order
    (chemical_type.display_order * 100_000) + (chemical_type.id * 1000) + (chemical.display_order * 100) + chemical_id
  end

  def quantity10
    sum_area = work.chemical_group_flag ? work.sum_areas(chemical_group_no) : work.sum_areas
    return sum_area.zero? ? 0 : (quantity / sum_area * 10).round(1)
  end

  def dilution_amount
    return dilution? && chemical.unit_scale.positive? ? (quantity * magnification / chemical.unit_scale).round(1) : quantity
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

  def areas
    if self.chemical_group_no.zero? || work.work_lands.where(chemical_group_no: self.chemical_group_no).empty?
      chemical_term = ChemicalTerm.find_by(term: work.term, chemical_id: chemical_id)
      work_type_ids = chemical_term ? chemical_term.work_types.map(&:id) : [work.work_type_id]
      land_ids = LandCost.by_work_type(work_type_ids, work.worked_at).by_land(work.work_lands.map(&:land_id)).map(&:land_id)
      Land.where(id: land_ids).sum(:area)
    else
      work.sum_areas(chemical_group_no)
    end
  end
end
