# == Schema Information
#
# Table name: chemical_inventories
#
#  id                 :bigint           not null, primary key
#  checked_on(確認日) :date             not null
#  name(棚卸名称)     :string(40)       default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class ChemicalInventory < ApplicationRecord
  has_many :stocks, class_name: :ChemicalStock, dependent: :destroy_all
end
