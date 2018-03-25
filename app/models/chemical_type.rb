# == Schema Information
#
# Table name: chemical_types # 薬剤種別マスタ
#
#  id            :integer          not null, primary key # 薬剤種別マスタ
#  name          :string(20)       not null              # 薬剤種別名称
#  display_order :integer          default(1), not null  # 表示順
#  created_at    :datetime
#  updated_at    :datetime
#

class ChemicalType < ApplicationRecord
  has_many :chemicals, -> {order("chemicals.display_order")}, dependent: :restrict_with_exception

  has_many :chemical_kinds
  has_many :work_kinds, through: :chemical_kinds

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: { only_integer: true }, :if => proc{|x| x.display_order.present?}
end
