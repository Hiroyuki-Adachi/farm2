# == Schema Information
#
# Table name: machine_reserve_fund_costs(基盤強化準備金原価(作業分類別))
#
#  id                                                     :bigint           not null, primary key
#  cost(原価)                                             :decimal(9, )     not null
#  created_at                                             :datetime         not null
#  updated_at                                             :datetime         not null
#  machine_reserve_fund_detail_id(基盤強化準備金原価明細) :bigint           not null
#  organization_id(組織)                                  :bigint           not null
#  work_type_id(作業分類)                                 :integer          not null
#
# Indexes
#
#  idx_on_machine_reserve_fund_detail_id_2e7d1eb058     (machine_reserve_fund_detail_id)
#  idx_reserve_fund_costs_on_detail_and_work_type       (machine_reserve_fund_detail_id,work_type_id) UNIQUE
#  index_machine_reserve_fund_costs_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_reserve_fund_detail_id => machine_reserve_fund_details.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFundCost < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :machine_reserve_fund_detail, optional: false
  belongs_to :work_type, optional: false

  validate :associations_same_organization

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  private

  def associations_same_organization
    return if organization_id.blank?

    if machine_reserve_fund_detail.present? && machine_reserve_fund_detail.organization_id != organization_id
      errors.add(:machine_reserve_fund_detail_id, :invalid)
    end
  end
end
