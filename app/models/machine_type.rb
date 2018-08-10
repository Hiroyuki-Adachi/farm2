# == Schema Information
#
# Table name: machine_types # 機械種別マスタ
#
#  id            :integer          not null, primary key # 機械種別マスタ
#  name          :string(10)       not null              # 機械種別名称
#  display_order :integer          default(1), not null  # 表示順
#  created_at    :datetime
#  updated_at    :datetime
#

class MachineType < ApplicationRecord
  has_many :machines, -> {order("machines.display_order, machines.id")}, dependent: :restrict_with_exception 

  has_many :machine_kinds
  has_many :work_kinds, -> {order("work_kinds.other_flag, work_kinds.display_order, work_kinds.id")}, {through: :machine_kinds, dependent: :destroy}
  has_many :price_headers, -> {order("machine_price_headers.validated_at DESC")}, {class_name: :MachinePriceHeader, dependent: :destroy}

  scope :usual, -> {order("display_order")}

  validates :name, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  def price_details(work)
    header = price_headers.where("validated_at <= ?", work.worked_at).order(validated_at: :DESC).first
    return header ? header.details : nil
  end

  def machine_type_order
    display_order * MachineType.maximum(:id) + id
  end
end
