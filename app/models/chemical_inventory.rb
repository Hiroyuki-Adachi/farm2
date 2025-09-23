# == Schema Information
#
# Table name: chemical_inventories(農薬棚卸)
#
#  id                                    :bigint           not null, primary key
#  checked_on(確認日)                    :date             not null
#  name(棚卸名称)                        :string(40)       default(""), not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  chemical_adjust_type_id(在庫調整種別) :integer          default(NULL), not null
#

class ChemicalInventory < ApplicationRecord
  enum :chemical_adjust_type_id, {inventory: 1, stored: 2, shipping: 3}

  validates :name, presence: true, length: {maximum: 40}
  validates :checked_on, presence: true
  has_many :stocks, class_name: 'ChemicalStock', dependent: :destroy
  accepts_nested_attributes_for :stocks, allow_destroy: true

  scope :inventories, -> {where(chemical_adjust_type_id: :inventory).order(:checked_on)}
  scope :stores, -> {where(chemical_adjust_type_id: :stored).order(:checked_on)}
end
