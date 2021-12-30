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

  validates :chemical_id, uniqueness: {scope: :chemical_inventory}

  scope :usual, -> (chemical_id) {
    where(chemical_id: chemical_id)
    .order(:stock_on, :id)
  }

  before_save :save_inventory

  def save_inventory
    if chemical_inventory_id
      self.name = chemical_inventory.name
      self.stock_on = chemical_inventory.checked_on
    end
  end

  def self.refresh(chemical_id)
    start_date = ChemicalStock.where(chemical_id: chemical_id).minimum(:stock_on)
    from_work(chemical_id, start_date)
    tmp_stock = 0
    ChemicalStock.usual(chemical_id).each do |stock|
      if stock.inventory.nil?
        stock.adjust = (stock.stored || 0) - (stock.using || 0) - (stock.shipping || 0)
        stock.stock = tmp_stock + stock.adjust
      else
        stock.stock = stock.inventory
        stock.adjust = stock.stock - tmp_stock
      end
      stock.save!
      tmp_stock = stock.stock
    end
  end

  def self.from_work(chemical_id, start_date)
    ChemicalStock.where(chemical_id: chemical_id).where.not(work_chemical_id: nil).destroy_all
    WorkChemical.for_stock(chemical_id, start_date).each do |work_chemical|
      ChemicalStock.create(
        work_chemical_id: work_chemical.id,
        chemical_id: chemical_id,
        stock_on: work_chemical.work.worked_at,
        name: "#{work_chemical.work.work_type.name}(#{work_chemical.work.work_kind.name})",
        using: work_chemical.quantity_for_stock
      )
    end
  end
end
