# == Schema Information
#
# Table name: chemicals(薬剤マスタ)
#
#  id(薬剤マスタ)             :integer          not null, primary key
#  aqueous_flag(水溶フラグ)   :boolean          default(FALSE), not null
#  base_quantity(消費数)      :decimal(6, )     default(0), not null
#  carton_quantity(購買数)    :decimal(6, )     default(0), not null
#  carton_unit(購買単位)      :string(2)        default(""), not null
#  deleted_at                 :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(薬剤名称)             :string(20)       not null
#  phonetic(薬剤ふりがな)     :string(40)       default(""), not null
#  stock_quantity(在庫数)     :decimal(6, )     default(0), not null
#  stock_unit(在庫単位)       :string(2)        default(""), not null
#  unit(単位)                 :string(2)        default("袋"), not null
#  url(URL)                   :string(255)      default(""), not null
#  created_at                 :datetime
#  updated_at                 :datetime
#  base_unit_id(基本単位)     :integer          default(0), not null
#  chemical_type_id(薬剤種別) :integer          not null
#
# Indexes
#
#  index_chemicals_on_deleted_at  (deleted_at)
#

class Chemical < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Discard::Model

  self.discard_column = :deleted_at

  attribute :total_quantity, :decimal

  after_save :save_term

  belongs_to :chemical_type
  belongs_to_active_hash :base_unit
  has_many :chemical_terms, dependent: :destroy
  has_many :stocks, class_name: 'ChemicalStock', dependent: :destroy
  has_many :work_chemicals, dependent: :destroy
  has_many :works, through: :work_chemicals

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}
  validates :phonetic,      presence: true
  validates :phonetic, format: { with: /\A[\p{Hiragana}ー－A-Z0-9]+\z/ }, if: proc { |x| x.phonetic.present?}

  attr_accessor :term

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :usual, ->(work) do
    kept.joins(:chemical_type)
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
  end

  scope :list, -> do
    kept.includes(:chemical_type)
    .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  end

  scope :by_term, ->(term) do
    kept
    joins(:chemical_type)
      .with_deleted
      .where(chemicals: { id: WorkChemical.by_term(term).pluck("work_chemicals.chemical_id").uniq })
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  end

  scope :for_stock, ->(term) do
    joins(:chemical_type)
      .with_deleted
      .where(chemicals: { id: ChemicalTerm.where(term: term).select("chemical_id") })
      .order(Arel.sql("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id"))
  end

  scope :by_type, ->(chemical_type_id) {where(chemical_type_id: chemical_type_id).order(:phonetic, :display_order, :id)}

  scope :by_work_kind, ->(work_kind_id) do
    joins(chemical_type: :chemical_kinds).includes(:chemical_type)
      .where(chemical_kinds: { work_kind_id: work_kind_id })
      .order("chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.id")
  end

  scope :with_total_quantity, ->(work) do
    joins(:work_chemicals)
    .where(work_chemicals: { work_id: work.id })
    .select('chemicals.*', 'SUM(work_chemicals.quantity) AS total_quantity')
    .group('chemicals.id')
  end

  def this_term_flag
    this_term?(@term)
  end

  def this_term?(term)
    chemical_terms.exists?(term: term)
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
    return quantity / 1_000_000 if quantity > 1_000_000
    return "" if quantity == 1_000_000
    return quantity / 1_000 if quantity > 1_000
    return "" if quantity == 1_000
    return quantity == 1 ? "" : quantity
  end

  attr_writer :this_term_flag

  private

  def save_term
    if ActiveRecord::Type::Boolean.new.cast(@this_term_flag)
      ChemicalTerm.create(term: @term, chemical_id: id) unless chemical_terms.exists?(term: @term)
    else
      chemical_terms.where(term: @term).destroy_all
    end
  end
end
