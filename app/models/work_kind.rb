# == Schema Information
#
# Table name: work_kinds # 作業種別マスタ
#
#  id            :integer          not null, primary key    # 作業種別マスタ
#  name          :string(20)       not null                 # 作業種別名称
#  display_order :integer          not null                 # 表示順
#  other_flag    :boolean          default(FALSE), not null # その他フラグ
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  land_flag     :boolean          default(TRUE), not null  # 土地利用フラグ
#

class WorkKind < ApplicationRecord
  acts_as_paranoid

  after_save :save_price

  has_many :machine_kinds
  has_many :machine_types,-> {order("machine_types.display_order")}, through: :machine_kinds 

  has_many :chemical_kinds
  has_many :chemical_types, -> {order("chemical_types.display_order")}, through: :chemical_kinds

  has_many :work_kind_types
  has_many :work_types, through: :work_kind_types
  has_many :work_kind_prices

  validates :name, presence: true
  validates :price, presence: true
  validates :display_order, presence: true

  validates :price, numericality: true, if: proc { |x| x.price.present? }
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present? }

  scope :usual, -> { where(other_flag: false).order(:display_order) }
  scope :by_type, -> (work_type) { 
     joins(:work_kind_types)
    .where("work_kind_types.work_type_id = ?", 
     work_type.genre_id).order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")
  }

  def price
    term_price(Organization.term)
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
      work_kind_price.update_attributes(price: @p_price)
    else
      WorkKindPrice.create(work_kind_id: id, term: term, price: @p_price)
    end
    Rails.cache.write(price_cache_key(term), @p_price, expires_in: 1.hour)
  end

  def price_cache_key(term)
    "work_kind_price_#{id}_#{term}"
  end
end
