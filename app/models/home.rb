class Home < ActiveRecord::Base
  acts_as_paranoid

  has_many :workers,  lambda{order(:display_order)}
  has_many :lands,    lambda{order(:place)}
  
  belongs_to :holder, {class_name: :Worker, foreign_key: :worker_id}
  belongs_to :section

  scope :usual, lambda{includes(:section).where(member_flag: true).order("sections.display_order, homes.display_order, homes.id")}

  validates :phonetic,      presence: true
  validates :name,          presence: true
  validates :display_order, presence: true
  
  validates :phonetic, format: {with: /\a[ぁ-ん]*\z/u}, :if => Proc.new{|x| x.phonetic.present?}
  validates :telephone, format: {with: /\d{2,4}-\d{2,4}-\d{4}/}, :if => Proc.new{|x| x.telephone.present?}
  
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def holder_name
    return self.holder ? self.holder.name : ''
  end
end
