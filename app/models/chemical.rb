# == Schema Information
#
# Table name: chemicals
#
#  id               :integer          not null, primary key
#  name             :string(20)       not null
#  display_order    :integer          default("0"), not null
#  chemical_type_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  deleted_at       :datetime
#  unit             :string(2)        default("袋"), not null
#  phonetic         :string(40)       default(""), not null
#  base_unit_id     :integer          default("0"), not null
#  base_quantity    :decimal(6, )     default("0.0"), not null
#  carton_unit      :string(2)        default(""), not null
#  carton_quantity  :decimal(6, )     default("0.0"), not null
#  aqueous_flag     :boolean          default("false"), not null
#  stock_unit       :string(2)        default(""), not null
#  stock_quantity   :decimal(6, )     default("0.0"), not null
#  url              :string(255)      default(""), not null
#
# Indexes
#
#  index_chemicals_on_deleted_at  (deleted_at)
#

class Chemical < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  acts_as_paranoid

  after_save :save_term

  belongs_to :chemical_type
  belongs_to_active_hash :base_unit
  has_many :chemical_terms, dependent: :destroy
  has_many :stocks, class_name: :ChemicalStock, dependent: :destroy

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
  scope :list, ->{includes(:chemical_type).order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))}

  scope :by_term, ->(term) {
    joins(:chemical_type)
      .with_deleted
      .where("chemicals.id IN (?)", WorkChemical.by_term(term).pluck("work_chemicals.chemical_id").uniq)
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  }

  scope :for_stock, ->(term) {
    joins(:chemical_type)
      .with_deleted
      .where("chemicals.id IN (?)", ChemicalTerm.where(term: term).pluck("chemical_id"))
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  }

  scope :by_type, ->(chemical_type_id) {where(chemical_type_id: chemical_type_id).order(:phonetic, :display_order, :id)}

  scope :by_work_kind, ->(work_kind_id) {
    joins(chemical_type: :chemical_kinds).includes(:chemical_type)
      .where("chemical_kinds.work_kind_id = ?", work_kind_id)
      .order("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.id")
  }

  def this_term_flag
    this_term?(@term)
  end

  def this_term?(term)
    chemical_terms.where(term: term).exists?
  end

  def base_unit_name
    unit_name(base_quantity)
  end

  def base_base_quantity
    unit_quantity(base_quantity)
  end

  def carton_unit_name
    unit_name(carton_quantity)
  end

  def carton_base_quantity
    unit_quantity(carton_quantity)
  end

  def stock_unit_name
    unit_name(stock_quantity)
  end

  def stock_base_quantity
    unit_quantity(stock_quantity)
  end

  def unit_scale
    return Unit.find_by(code: unit).scale
  end

  def unit_name(quantity)
    return base_unit.mega_name if quantity >= 1_000_000
    return base_unit.kilo_name if quantity >= 1_000
    return base_unit.name
  end

  def unit_quantity(quantity)
    return (quantity / 1_000_000) if quantity >= 1_000_000
    return (quantity / 1_000) if quantity >= 1_000
    return quantity
  end

  attr_writer :this_term_flag

  private

  def save_term
    if ActiveRecord::Type::Boolean.new.cast(@this_term_flag)
      ChemicalTerm.create(term: @term, chemical_id: id) unless chemical_terms.where(term: @term).exists?
    else
      chemical_terms.where(term: @term).destroy_all
    end
  end
end
