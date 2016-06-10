# == Schema Information
#
# Table name: work_kinds
#
#  id            :integer          not null, primary key
#  name          :string(20)       not null
#  display_order :integer          not null
#  other_flag    :boolean          default(FALSE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

class WorkKind < ActiveRecord::Base
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

  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
  validates :display_order, numericality: {only_integer: true}, if: Proc.new{|x| x.display_order.present?}

  scope :usual, -> {where(other_flag: false).order(:display_order)}
  scope :by_type, -> (work_type){joins(:work_kind_types).where("work_kind_types.work_type_id = ?", work_type.genre_id).order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")}
  
  def price
    work_kind_price = WorkKindPrice.usual(self).first
    return work_kind_price ? work_kind_price.price : 0
  end
  
  def price=(val)
    @price = val
  end
  
  def term_price(term)
    term_price = WorkKindPrice.by_term(self, term).first
    return term_price ? term_price.price : 0
  end
  
  private
  def save_price
    term = Organization.first.term
    work_kind_price = WorkKindPrice.where(work_kind_id: id, term: term).order(:id).first
    if work_kind_price
      work_kind_price.update_attributes(price: @price)
    else
      WorkKindPrice.create(work_kind_id: id, term: term, price: @price)
    end
  end
end
