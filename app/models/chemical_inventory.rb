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
  belongs_to :adjust_type, class_name: :ChemicalAdjustType
  has_many :stocks, class_name: :ChemicalStock, dependent: :destroy
end
