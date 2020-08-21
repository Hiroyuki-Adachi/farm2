# == Schema Information
#
# Table name: work_kinds # 作業種別マスタ
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
#
# Indexes
#
#  index_work_kinds_on_deleted_at  (deleted_at)
#
class WorkKind < ApplicationRecord
  acts_as_paranoid

  after_save :save_price

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

  validates :price, numericality: true, if: proc { |x| x.price.present?}
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  scope :usual, -> {where(other_flag: false).order(:phonetic, :display_order, :id)}
  scope :by_type, ->(work_type) {
    joins(:work_kind_types)
      .where(["work_kind_types.work_type_id = ?", work_type.genre_id])
      .order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")
  }

  def price
    new_record? ? @p_price : term_price(Organization.term)
  end

  def price=(val)
    @p_price = val.to_i
  end

  def term_price(term)
    cache_key = price_cache_key(term)
    price_value = 0
    if Rails.cache.exist?(cache_key)
      price_value = Rails.cache.read(cache_key)
    else
      work_kind_price = WorkKindPrice.by_term(self, term).first
      price_value = work_kind_price ? work_kind_price.price : 0
      Rails.cache.write(cache_key, price_value, expires_in: 1.hour)
    end
    return price_value
  end

  private

  def save_price
    term = Organization.term
    work_kind_price = WorkKindPrice.where(work_kind_id: id, term: term).order(:id).first
    if work_kind_price
      work_kind_price.update(price: @p_price)
    else
      WorkKindPrice.create(work_kind_id: id, term: term, price: @p_price)
    end
    Rails.cache.write(price_cache_key(term), @p_price, expires_in: 1.hour)
  end

  def price_cache_key(term)
    "work_kind_price_#{id}_#{term}"
  end
end
