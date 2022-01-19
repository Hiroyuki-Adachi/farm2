# == Schema Information
#
# Table name: chemical_stocks
#
#  id                    :integer          not null, primary key
#  stock_on              :date             not null
#  chemical_id           :integer          not null
#  work_chemical_id      :integer
#  chemical_inventory_id :integer
#  name                  :string(40)       default(""), not null
#  stored                :decimal(5, 1)
#  shipping              :decimal(5, 1)
#  using                 :decimal(5, 1)
#  inventory             :decimal(7, 1)
#  stock                 :decimal(7, 1)    default("0.0"), not null
#  adjust                :decimal(5, 1)    default("0.0"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class ChemicalStock < ApplicationRecord
  belongs_to :chemical
  belongs_to :work_chemical
  belongs_to :chemical_inventory

  validates :chemical_id, uniqueness: {scope: :chemical_inventory}, if: :valid_chemical_id?

  scope :usual, -> (chemical_id) {
    where(chemical_id: chemical_id)
    .order(:stock_on, :id)
  }

  before_save :save_inventory
  before_save :save_stored

  def save_inventory
    if chemical_inventory_id
      self.name = chemical_inventory.name
      self.stock_on = chemical_inventory.checked_on
    end
  end

  def save_stored
    if @stored_stock_value
      self.stored = (chemical.carton_quantity.zero? ? @stored_stock_value : @stored_stock_value.to_f * chemical.carton_quantity / chemical.stock_quantity)
    end
  end

  def self.refresh(organization_id, chemical_id)
    start_date = ChemicalStock.where(chemical_id: chemical_id).minimum(:stock_on)
    from_work(chemical_id, start_date)
    create_begin(organization_id, chemical_id, start_date)
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

  def self.create_begin(organization_id, chemical_id, start_date)
    System.where("start_date > ? AND organization_id = ?", start_date, organization_id).order(:start_date).each do |sys|
      unless ChemicalStock.where("chemical_id = ? AND stock_on = ?", chemical_id, sys.start_date).exists?
        ChemicalStock.create(
          name: "期首在庫",
          stock_on: sys.start_date,
          chemical_id: chemical_id
        )
      end
    end
  end

  def self.from_work(chemical_id, start_date)
    ChemicalStock.where(chemical_id: chemical_id).where.not(work_chemical_id: nil).update_all("\"using\" = 0")
    WorkChemical.for_stock(chemical_id, start_date).each do |work_chemical|
      stock = ChemicalStock.find_by(work_chemical_id: work_chemical.id)
      if stock
        stock.stock_on = work_chemical.work.worked_at
        stock.name = "#{work_chemical.work.work_type.name}(#{work_chemical.work.work_kind.name})"
        stock.using = work_chemical.quantity_for_stock
        stock.save!
      else
        ChemicalStock.create(
          work_chemical_id: work_chemical.id,
          chemical_id: chemical_id,
          stock_on: work_chemical.work.worked_at,
          name: "#{work_chemical.work.work_type.name}(#{work_chemical.work.work_kind.name})",
          using: work_chemical.quantity_for_stock
        )
      end
    end
    ChemicalStock.where(chemical_id: chemical_id).where.not(work_chemical_id: nil).where(using: 0).destroy_all
  end

  def editable?
    work_chemical_id.nil? && inventory.nil?
  end

  def valid_chemical_id?
    chemical_inventory_id.present?
  end

  def stored_stock
    return nil if stored.nil?
    chemical.stock_quantity.zero? ? stored : stored * chemical.stock_quantity / chemical.carton_quantity
  end

  def stored_stock=(value)
    self.stored = 0
    @stored_stock_value = value
  end
end
