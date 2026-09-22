# == Schema Information
#
# Table name: machine_reserve_funds(基盤強化準備金原価)
#
#  id                    :bigint           not null, primary key
#  started_on(開始年月)  :date             not null
#  total_amount(総額)    :decimal(9, )     not null
#  years(配分年数)       :integer          default(7), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  machine_id(機械)      :integer          not null
#  organization_id(組織) :bigint           not null
#
# Indexes
#
#  index_machine_reserve_funds_on_machine_id       (machine_id) UNIQUE
#  index_machine_reserve_funds_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFund < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :machine, optional: false

  has_many :machine_reserve_fund_details, dependent: :restrict_with_exception

  validates :started_on, presence: true
  validates :years, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :machine_id, uniqueness: true
  validate :total_amount_not_less_than_registered_amount

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  def registered_amount
    machine_reserve_fund_details.sum(:amount)
  end

  def remaining_amount
    total_amount - registered_amount
  end

  def details?
    machine_reserve_fund_details.exists?
  end

  private

  # 登録済み明細の合計額より小さい総額には変更できない(登録済み分を後退させないため)
  def total_amount_not_less_than_registered_amount
    return if total_amount.nil?

    errors.add(:total_amount, "は登録済みの原価額より小さくできません。") if total_amount < registered_amount
  end
end
