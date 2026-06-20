# == Schema Information
#
# Table name: zengin_payments(全銀支払先)
#
#  id                                      :bigint           not null, primary key
#  account_holder_name(口座氏名(半角カナ)) :string(30)       default(""), not null
#  account_number(口座番号)                :string(7)        default(""), not null
#  amount(支払額)                          :decimal(10, )    default(0), not null
#  bank_code(銀行コード)                   :string(4)        default(""), not null
#  branch_code(支店コード)                 :string(3)        default(""), not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  account_type_id(口座種別)               :integer          default("unset"), not null
#  worker_id(作業者)                       :bigint           not null
#  zengin_payment_batch_id(全銀支払バッチ) :bigint           not null
#
# Indexes
#
#  index_zengin_payments_on_batch_and_worker         (zengin_payment_batch_id,worker_id) UNIQUE
#  index_zengin_payments_on_worker_id                (worker_id)
#  index_zengin_payments_on_zengin_payment_batch_id  (zengin_payment_batch_id)
#
# Foreign Keys
#
#  fk_rails_...  (worker_id => workers.id)
#  fk_rails_...  (zengin_payment_batch_id => zengin_payment_batches.id)
#
class ZenginPayment < ApplicationRecord
  enum :account_type_id, { unset: 0, regular: 1, current: 2, savings: 4 }, prefix: true

  belongs_to :zengin_payment_batch
  belongs_to :worker, -> { with_deleted }
  has_many :zengin_payment_details, dependent: :destroy

  validates :amount, presence: true
  validates :bank_code, length: { maximum: 4 }
  validates :branch_code, length: { maximum: 3 }
  validates :account_number, length: { maximum: 7 }
  validates :account_holder_name, length: { maximum: 30 }
end
