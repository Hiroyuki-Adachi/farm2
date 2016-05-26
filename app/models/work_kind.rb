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
  
  def price
    work_kind_prices = WorkKindPrice.usual(self)
    return work_kind_prices.exists? ? work_kind_prices.first.price : 0; 
  end
  
  def price=(val)
    @price = val
  end
  
  def save_price
    term = System.first.term
    work_kind_price = WorkKindPrice.where(work_kind_id: self.id, term: term).order(:id)
    if work_kind_price.exists?
      work_kind_price.first.update_attributes(price: @price)
    else
      WorkKindPrice.create(work_kind_id: self.id, term: term, price: @price)
    end
  end
end
