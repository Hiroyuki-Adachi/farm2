# == Schema Information
#
# Table name: chemical_inventories
#
#  id                                    :bigint           not null, primary key
#  checked_on(確認日)                    :date             not null
#  name(棚卸名称)                        :string(40)       default(""), not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  chemical_adjust_type_id(在庫調整種別) :integer          default(0), not null
#
class ChemicalInventory < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to_active_hash :adjust_type, class_name: "ChemicalAdjustType"
  has_many :stocks, class_name: :ChemicalStock, dependent: :destroy
  accepts_nested_attributes_for :stocks, allow_destroy: true

  scope :inventories, -> {where(chemical_adjust_type_id: ChemicalAdjustType::INVENTORY).order(:checked_on)}
  scope :stores, -> {where(chemical_adjust_type_id: ChemicalAdjustType::STORED).order(:checked_on)}

  def inventory?
    chemical_adjust_type_id == ChemicalAdjustType::INVENTORY.id
  end

  def stored?
    chemical_adjust_type_id == ChemicalAdjustType::STORED.id
  end
end
