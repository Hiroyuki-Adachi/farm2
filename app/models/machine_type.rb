# == Schema Information
#
# Table name: machine_types
#
#  id            :integer          not null, primary key
#  name          :string(10)       not null
#  display_order :integer          default(1), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class MachineType < ActiveRecord::Base
  has_many :machines, -> {order("machines.display_order, machines.id")}, dependent: :restrict_with_exception 

  has_many :machine_kinds
  has_many :work_kinds, -> {order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")}, {through: :machine_kinds, dependent: :destroy}
  has_many :price_headers, {class_name: :MachinePriceHeader, dependent: :destroy}, -> {order("machine_price_headers.validated_at DESC")}
  
  scope :usual, ->{order("display_order")}

  validates :name, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def price_details(work)
    return price_headers.where("validated_at <= ?", work.worked_at).order("validated_at").first
  end
end
