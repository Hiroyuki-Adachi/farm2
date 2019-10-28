# == Schema Information
#
# Table name: chemicals # 薬剤マスタ
#
#  id               :integer          not null, primary key  # 薬剤マスタ
#  name             :string(20)       not null               # 薬剤名称
#  display_order    :integer          default(0), not null   # 表示順
#  chemical_type_id :integer          not null               # 薬剤種別
#  created_at       :datetime
#  updated_at       :datetime
#  deleted_at       :datetime
#  unit             :string(2)        default("袋"), not null # 単位
#

class Chemical < ApplicationRecord
  acts_as_paranoid

  after_save :save_term

  belongs_to :chemical_type
  has_many :chemical_terms, {dependent: :delete_all}

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  attr_accessor :term

  scope :usual, ->(work) {
    joins(:chemical_type)
      .where(<<-WHERE, work.term, work.work_kind.chemical_kinds.pluck(:chemical_type_id), ChemicalWorkType.by_work(work).map(&:chemical).map(&:id), work.chemicals.pluck(:chemical_id))
            (
                  chemicals.id IN (SELECT chemical_id FROM chemical_terms WHERE term = ?)
              AND chemicals.id IN (?)
              AND chemicals.chemical_type_id IN (?)
            ) 
         OR chemicals.id IN (?)
WHERE
      .order(Arel.sql(<<-ORDER))
        chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id
ORDER
  }
  scope :list, ->{includes(:chemical_type).order(Arel.sql("chemical_types.display_order, chemicals.display_order, chemicals.id"))}

  scope :by_work, ->(term) {
    joins(:chemical_type)
      .with_deleted
      .where("chemicals.id IN (?)", WorkChemical.by_work(term).pluck("work_chemicals.chemical_id").uniq)
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id"))
  }

  scope :by_type, ->(chemical_type_id) {where(chemical_type_id: chemical_type_id).order(:display_order, :id)}

  def this_term_flag
    chemical_terms.where(term: @term).exists?
  end

  attr_writer :this_term_flag

  private

  def save_term
    @term ||= Organization.first.term
    if ActiveRecord::Type::Boolean.new.cast(@this_term_flag)
      ChemicalTerm.create(term: @term, chemical_id: id) unless chemical_terms.where(term: @term).exists?
    else
      chemical_terms.where(term: @term).destroy_all
    end
  end
end
