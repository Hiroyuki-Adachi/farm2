# == Schema Information
#
# Table name: chemicals # 薬剤マスタ
#
#  id(薬剤マスタ)             :integer          not null, primary key
#  deleted_at                 :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(薬剤名称)             :string(20)       not null
#  phonetic(薬剤ふりがな)     :string(40)       default(""), not null
#  unit(単位)                 :string(2)        default("袋"), not null
#  created_at                 :datetime
#  updated_at                 :datetime
#  chemical_type_id(薬剤種別) :integer          not null
#
# Indexes
#
#  index_chemicals_on_deleted_at  (deleted_at)
#

class Chemical < ApplicationRecord
  acts_as_paranoid

  after_save :save_term

  belongs_to :chemical_type
  has_many :chemical_terms, {dependent: :delete_all}

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}
  validates :phonetic,      presence: true
  validates :phonetic, format: { with: /\A[\p{Hiragana}ー－A-Z0-9]+\z/ }, if: proc { |x| x.phonetic.present?}

  attr_accessor :term

  scope :usual, ->(work) {
    joins(:chemical_type)
      .where(<<-WHERE, work.term, ChemicalWorkType.by_work(work).map(&:chemical).map(&:id), work.work_kind.chemical_kinds.pluck(:chemical_type_id), work.chemicals.pluck(:chemical_id))
            (
                  chemicals.id IN (SELECT chemical_id FROM chemical_terms WHERE term = ?)
              AND chemicals.id IN (?)
              AND chemicals.chemical_type_id IN (?)
            ) 
         OR chemicals.id IN (?)
WHERE
      .order(Arel.sql(<<-ORDER))
        chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id
ORDER
  }
  scope :list, ->{includes(:chemical_type).order(Arel.sql("chemical_types.display_order, chemicals.phonetic, chemicals.display_order, chemicals.id"))}

  scope :by_work, ->(term) {
    joins(:chemical_type)
      .with_deleted
      .where("chemicals.id IN (?)", WorkChemical.by_work(term).pluck("work_chemicals.chemical_id").uniq)
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  }

  scope :by_type, ->(chemical_type_id) {where(chemical_type_id: chemical_type_id).order(:phonetic, :display_order, :id)}

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
