# == Schema Information
#
# Table name: chemical_types
#
#  id            :integer          not null, primary key
#  name          :string(20)       not null
#  display_order :integer          default("1"), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ChemicalType < ApplicationRecord
  has_many :chemicals, -> {order("chemicals.display_order")}, dependent: :restrict_with_exception
  has_many :chemical_kinds
  has_many :work_kinds, through: :chemical_kinds

  scope :usual, -> {order(:display_order, :id)}

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => proc{|x| x.display_order.present?}
end
