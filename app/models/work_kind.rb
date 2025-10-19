# == Schema Information
#
# Table name: work_kinds(作業種別マスタ)
#
#  id(作業種別マスタ)            :integer          not null, primary key
#  broccoli_mark(ブロッコリ記号) :string(1)
#  deleted_at                    :datetime
#  display_order(表示順)         :integer          not null
#  land_flag(土地利用フラグ)     :boolean          default(TRUE), not null
#  name(作業種別名称)            :string(20)       not null
#  other_flag(その他フラグ)      :boolean          default(FALSE), not null
#  phonetic(作業種別ふりがな)    :string(40)       default(""), not null
#  created_at                    :datetime
#  updated_at                    :datetime
#  cost_type_id(原価種別)        :integer
#
# Indexes
#
#  index_work_kinds_on_deleted_at  (deleted_at)
#

class WorkKind < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at

  after_save :save_price

  belongs_to :cost_type

  has_many :machine_kinds, dependent: :destroy
  has_many :machine_types, -> {order("machine_types.display_order")}, through: :machine_kinds 

  has_many :chemical_kinds, dependent: :destroy
  has_many :chemical_types, -> {order("chemical_types.display_order")}, through: :chemical_kinds

  has_many :work_kind_types, dependent: :destroy
  has_many :work_types, through: :work_kind_types
  has_many :work_kind_prices, dependent: :destroy

  has_many :calendar_work_kinds, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true
  validates :phonetic, presence: true
  validates :phonetic, format: { with: /\A[\p{Hiragana}ー－A-Z0-9]+\z/ }, if: proc { |x| x.phonetic.present?}
  validates :display_order, presence: true

  validates :price, numericality: true, if: proc { |x| x.price.present? && @term.present? }
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :usual, -> { except_other.order(:phonetic, :display_order, :id) }
  scope :landable, ->{kept.where(land_flag: true)}
  scope :by_type, ->(work_type) {
    kept
      .joins(:work_kind_types)
      .where(work_kind_types: { work_category_id: work_type&.genre&.work_category_id })
      .order("work_kinds.other_flag, work_kinds.phonetic, work_kinds.display_order, work_kinds.id")
  }
  scope :except_other, -> {kept.where(other_flag: false) }
  scope :gaps, -> {kept.where.not(broccoli_mark: [nil, ""]).group(:broccoli_mark).order(:broccoli_mark).select("broccoli_mark, MAX(name) AS name")}

  attr_writer :price
  attr_accessor :term

  def term_price(term)
    cache_key = price_cache_key(term)
    price_value = 0
    if Rails.cache.exist?(cache_key)
      price_value = Rails.cache.read(cache_key)
    else
      price_value = WorkKindPrice.price(self, term)
      Rails.cache.write(cache_key, price_value, expires_in: 1.hour)
    end
    return price_value
  end

  def price
    term_price(@term)
  end

  def self.find_other
    find_by(other_flag: true)
  end

  private

  def save_price
    work_kind_price = WorkKindPrice.find_by(work_kind_id: id, term: @term)
    if work_kind_price
      work_kind_price.update(price: @price)
    else
      WorkKindPrice.create(work_kind_id: id, term: @term, price: @price)
    end
    Rails.cache.write(price_cache_key(@term), @price, expires_in: 1.hour)
  end

  def price_cache_key(term)
    "work_kind_price_#{id}_#{term}"
  end
end
