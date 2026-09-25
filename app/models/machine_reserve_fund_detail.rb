# == Schema Information
#
# Table name: machine_reserve_fund_details(基盤強化準備金原価明細)
#
#  id                                          :bigint           not null, primary key
#  amount(原価額)                              :decimal(9, )     not null
#  months(按分月数)                            :integer          not null
#  remaining_amount(残額)                      :decimal(9, )     not null
#  term(年度(期))                              :integer          not null
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  machine_reserve_fund_id(基盤強化準備金原価) :bigint           not null
#  organization_id(組織)                       :bigint           not null
#
# Indexes
#
#  idx_reserve_fund_details_on_fund_and_term                      (machine_reserve_fund_id,term) UNIQUE
#  index_machine_reserve_fund_details_on_machine_reserve_fund_id  (machine_reserve_fund_id)
#  index_machine_reserve_fund_details_on_organization_id          (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_reserve_fund_id => machine_reserve_funds.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFundDetail < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :machine_reserve_fund, optional: false

  has_many :machine_reserve_fund_costs, dependent: :destroy

  validate :associations_same_organization

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  private

  def associations_same_organization
    return if organization_id.blank?

    if machine_reserve_fund.present? && machine_reserve_fund.organization_id != organization_id
      errors.add(:machine_reserve_fund_id, :invalid)
    end
  end
end
