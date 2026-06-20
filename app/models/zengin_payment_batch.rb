# == Schema Information
#
# Table name: zengin_payment_batches(全銀支払バッチ)
#
#  id                           :bigint           not null, primary key
#  account_number(口座番号)     :string(7)        default(""), not null
#  bank_code(銀行コード)        :string(4)        default(""), not null
#  branch_code(支店コード)      :string(3)        default(""), not null
#  consignor_code(委託者コード) :string(10)       default(""), not null
#  consignor_name(委託者名)     :string(40)       default(""), not null
#  created_by(作成者)           :integer
#  exported_at(出力日時)        :datetime
#  fixed_at(確定日)             :date             not null
#  status(状態)                 :integer          default("draft"), not null
#  term(年度(期))               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  account_type_id(口座種別)    :integer          default("unset"), not null
#  organization_id(組織)        :bigint           not null
#
# Indexes
#
#  index_zengin_payment_batches_on_fix_key          (organization_id,term,fixed_at) UNIQUE
#  index_zengin_payment_batches_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class ZenginPaymentBatch < ApplicationRecord
  enum :status, { draft: 0, exported: 1 }, prefix: true
  enum :account_type_id, { unset: 0, regular: 1, current: 2, savings: 4 }, prefix: true

  belongs_to :organization
  belongs_to :creator, -> { with_deleted }, class_name: "Worker", foreign_key: "created_by", optional: true
  has_many :zengin_payments, dependent: :destroy
  has_many :zengin_payment_details, through: :zengin_payments

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  validates :term, presence: true
  validates :fixed_at, presence: true
  validates :consignor_code, length: { maximum: 10 }
  validates :consignor_name, length: { maximum: 40 }
  validates :bank_code, length: { maximum: 4 }
  validates :branch_code, length: { maximum: 3 }
  validates :account_number, length: { maximum: 7 }
end
