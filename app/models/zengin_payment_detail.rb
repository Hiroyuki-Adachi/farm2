# == Schema Information
#
# Table name: zengin_payment_details(全銀支払明細)
#
#  id                            :bigint           not null, primary key
#  amount(金額)                  :decimal(10, )    default(0), not null
#  original_amount(元金額)       :decimal(10, )    default(0), not null
#  payment_type(支払種別)        :integer          not null
#  remarks(備考)                 :string(120)
#  source_kind(作成種別)         :integer          default("generated"), not null
#  source_label(元データ表示名)  :string(80)
#  source_type(元データ種別)     :string(40)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  source_id(元データID)         :bigint
#  zengin_payment_id(全銀支払先) :bigint           not null
#
# Indexes
#
#  index_zengin_payment_details_on_source_type_and_source_id  (source_type,source_id)
#  index_zengin_payment_details_on_zengin_payment_id          (zengin_payment_id)
#
# Foreign Keys
#
#  fk_rails_...  (zengin_payment_id => zengin_payments.id)
#
class ZenginPaymentDetail < ApplicationRecord
  enum :payment_type, {
    daily_wage: 0,
    land_management_fee: 1,
    tenant_land_management_fee: 2,
    machine_rental_fee: 3,
    seedling_fee: 4,
    drying_adjustment_fee: 5,
    other: 99
  }, prefix: true
  enum :source_kind, { generated: 0, manual: 1, imported: 2 }, prefix: true

  belongs_to :zengin_payment

  validates :payment_type, presence: true
  validates :source_kind, presence: true
  validates :amount, presence: true
  validates :original_amount, presence: true
  validates :source_label, length: { maximum: 80 }
  validates :remarks, length: { maximum: 120 }

  def amount_modified?
    amount.to_i != original_amount.to_i
  end
end
