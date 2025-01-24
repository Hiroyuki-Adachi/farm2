# == Schema Information
#
# Table name: chemical_inventories(農薬棚卸)
#
#  id                                 :bigint           not null, primary key
#  checked_on(確認日)                 :date             not null
#  chemical_adjust_type(在庫調整種別) :integer          default(NULL), not null
#  name(棚卸名称)                     :string(40)       default(""), not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#

class ChemicalInventory < ApplicationRecord
  enum :chemical_adjust_type, {inventory: 1, stored: 2, shipping: 3}

  has_many :stocks, class_name: :ChemicalStock, dependent: :destroy
  accepts_nested_attributes_for :stocks, allow_destroy: true

  scope :inventories, -> {where(chemical_adjust_type: :inventory).order(:checked_on)}
  scope :stores, -> {where(chemical_adjust_type: :stored).order(:checked_on)}

  def chemical_adjust_type_name
    I18n.t("activerecord.attributes.chemical_inventory.chemical_adjust_types.#{chemical_adjust_type}")
  end
end
