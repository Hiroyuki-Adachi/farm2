# == Schema Information
#
# Table name: chemical_stocks
#
#  id                              :bigint           not null, primary key
#  name(在庫名称)                  :string(40)       default(""), not null
#  shipping(出庫量)                :decimal(5, 1)    default(0.0), not null
#  stock(在庫量)                   :decimal(7, 1)    default(0.0), not null
#  stock_on(在庫日)                :date             not null
#  stored(入庫量)                  :decimal(5, 1)    default(0.0), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  chemical_id(薬剤)               :integer          not null
#  chemical_inventory_id(薬剤使用) :integer
#  work_chemical_id(薬剤使用)      :integer
#
class ChemicalStock < ApplicationRecord
  belongs_to :chemical
  belongs_to :work_chemical
  belongs_to :chemical_inventory

  validates :chemical_id, uniqueness: { scope: :chemical_inventory}

  before_save :save_inventory

  def save_inventory
    if chemical_inventory_id
      self.name = chemical_inventory.name
      self.stock_on = chemical_inventory.checked_on
    end
  end
end
