# == Schema Information
#
# Table name: chemical_work_types
#
#  id                         :integer          not null, primary key
#  quantity(使用量)           :decimal(5, 1)    default(0.0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  chemical_term_id(薬剤利用) :integer
#  work_type_id(作業分類)     :integer
#
# Indexes
#
#  index_chemical_work_types_on_chemical_term_id_and_work_type_id  (chemical_term_id,work_type_id) UNIQUE
#

class ChemicalWorkType < ApplicationRecord
  belongs_to :chemical_term
  belongs_to :work_type
  delegate :chemical, to: :chemical_term
  after_save :save_for_zero

  scope :by_chemical_terms, ->(chemical_terms) {where(chemical_term_id: chemical_terms.pluck(:id)).includes(:work_type, :chemical_term)}
  scope :by_chemical_term,  ->(chemical_term) {where(chemical_term_id: chemical_term).includes(:work_type, :chemical_term)}
  scope :usable, ->(chemical_term) {where(chemical_term_id: chemical_term).where("quantity > 0")}
  scope :by_work, ->(work) {
    joins(chemical_term: :chemical)
    .where(["chemical_work_types.work_type_id IN (?) AND chemical_work_types.quantity > 0 AND chemical_terms.term = ?",
            work.exact_work_types.map(&:id), work.term])
  }

  def self.regist_quantity(params)
    params.each do |param|
      chemical_work_type = ChemicalWorkType.find_by(id: param[:id]) if param[:id].present?
      if chemical_work_type
        chemical_work_type.update(quantity: param[:quantity])
      else
        ChemicalWorkType.create(chemical_work_type_params(param))
      end
    end
  end

  def self.chemical_work_type_params(param)
    param.permit(:chemical_term_id, :work_type_id, :quantity)
  end

  def self.by_work_chemical(work_chemical, work_type_id)
    joins(chemical_term: :chemical)
    .find_by(<<SQL.squish, work_type_id, work_chemical.work.term, work_chemical.chemical_id)
          chemical_work_types.work_type_id = ? 
      AND chemical_terms.term = ?
      AND chemical_terms.chemical_id = ?
SQL
  end

  def self.annual_update(old_term, new_term)
    ChemicalWorkType.joins(:chemical_term).where("chemical_terms.term = ?", old_term).find_each do |chemical_work_type|
      next if chemical_work_type.quantity.zero?
      next unless WorkTypeTerm.where(term: new_term, work_type_id: chemical_work_type.work_type_id)
      chemical_term = ChemicalTerm.find_by(chemical_id: chemical_work_type.chemical_term.chemical_id, term: new_term)
      next if chemical_term.nil?
      next if ChemicalWorkType.where(chemical_term_id: chemical_term, work_type_id: chemical_work_type.work_type_id).exists?
      ChemicalWorkType.create(
        chemical_term_id: chemical_term.id,
        quantity: chemical_work_type.quantity,
        work_type_id: chemical_work_type.work_type_id,
      )
    end
  end

  private

  def save_for_zero
    self.destroy if self.quantity.zero?
  end
end
