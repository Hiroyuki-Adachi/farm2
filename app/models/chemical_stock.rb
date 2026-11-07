# == Schema Information
#
# Table name: chemical_stocks(農薬在庫)
#
#  id                              :bigint           not null, primary key
#  adjust(調整量)                  :decimal(7, 1)    default(0.0), not null
#  inventory(棚卸量)               :decimal(8, 1)
#  name(在庫名称)                  :string(40)       default(""), not null
#  shipping(出庫量)                :decimal(7, 1)
#  stock(在庫量)                   :decimal(8, 1)    default(0.0), not null
#  stock_on(在庫日)                :date             not null
#  stored(入庫量)                  :decimal(7, 1)
#  using(使用量)                   :decimal(7, 1)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  chemical_id(薬剤)               :integer          not null
#  chemical_inventory_id(薬剤棚卸) :integer
#  organization_id(組織)           :bigint           not null
#  work_chemical_id(薬剤使用)      :integer
#
# Indexes
#
#  idx_on_organization_id_chemical_id_stock_on_ccf855096c  (organization_id,chemical_id,stock_on)
#  index_chemical_stocks_on_organization_id                (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class ChemicalStock < ApplicationRecord
  belongs_to :organization
  belongs_to :chemical
  belongs_to :work_chemical
  belongs_to :chemical_inventory

  validates :chemical_id, uniqueness: { scope: [:organization_id, :chemical_inventory_id] }, if: :valid_chemical_id?
  validate :associations_same_organization

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :usual, lambda { |chemical_id, organization = nil|
    where(chemical_id: chemical_id)
      .then { |base| organization ? base.for_organization(organization) : base }
      .order(:stock_on, :id)
  }

  before_save :save_inventory
  before_save :save_stored

  def save_inventory
    return unless chemical_inventory

    self.name = chemical_inventory.name
    self.stock_on = chemical_inventory.checked_on
    self.organization_id = chemical_inventory.organization_id
  end

  def save_stored
    if @stored_stock_value
      self.stored = (chemical.carton_quantity.zero? ? @stored_stock_value : @stored_stock_value.to_f * chemical.carton_quantity / chemical.stock_quantity)
    end
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

  private

  def associations_same_organization
    return if organization_id.blank?

    errors.add(:chemical_id, :invalid) if chemical.present? && chemical.organization_id != organization_id
    errors.add(:chemical_inventory_id, :invalid) if chemical_inventory.present? && chemical_inventory.organization_id != organization_id
    errors.add(:work_chemical_id, :invalid) if work_chemical.present? && work_chemical.work.organization_id != organization_id
  end
end
