class WorkKind < ActiveRecord::Base
  acts_as_paranoid

  has_many :machine_kinds
  has_many :machines, {:order => 'machines.display_order', :through => :machine_kinds}

  has_many :chemical_kinds
  has_many :chemical_types, {:order => 'chemical_types.display_order', :through => :chemical_kinds}

  validates_presence_of :name
  validates_presence_of :price
  validates_presence_of :display_order

  validates_numericality_of :price,  :if => Proc.new{|x| x.price.present?}
  validates_numericality_of :display_order, :only_integer =>true, :if => Proc.new{|x| x.display_order.present?}

  named_scope :usual, {:conditions => ['other_flag = ?', false], :order => 'display_order'}
end
