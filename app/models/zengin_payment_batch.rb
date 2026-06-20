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
  def self.rebuild_for_fix!(organization:, term:, fixed_at:, created_by:)
    organization = Organization.find(organization) unless organization.is_a?(Organization)
    fixed_at = fixed_at.to_date

    transaction do
      for_organization(organization).find_by(term: term, fixed_at: fixed_at)&.destroy!

      batch = create!(
        organization: organization,
        term: term,
        fixed_at: fixed_at,
        consignor_code: organization.consignor_code.to_s,
        consignor_name: organization.consignor_name.to_s,
        bank_code: organization.bank_code.to_s,
        branch_code: organization.branch_code.to_s,
        account_type_id: organization.account_type_id,
        account_number: organization.account_number.to_s,
        created_by: created_by
      )

      append_daily_wages(batch)
      append_machine_rental_fees(batch)

      batch.reload
    end
  end

  class << self
    private

    def append_daily_wages(batch)
      work_results = WorkResult
        .joins(:work)
        .includes(:work, worker: { home: :holder })
        .where(works: { organization_id: batch.organization_id, term: batch.term, fixed_at: batch.fixed_at })
        .where.not(fixed_amount: nil)

      work_results.find_each do |work_result|
        amount = work_result.fixed_amount.to_i
        next if amount.zero?

        worker = work_result.worker.payment || work_result.worker
        next unless worker.home.member_flag?

        payment = payment_for_worker(batch, worker)
        append_detail(
          payment,
          payment_type: :daily_wage,
          amount: amount,
          source: work_result,
          source_label: "日当 #{work_result.work.worked_at.strftime('%Y-%m-%d')}"
        )
      end
    end

    def append_machine_rental_fees(batch)
      machine_results = MachineResult
        .for_fix(batch.term, batch.fixed_at, batch.organization_id)
        .includes(:work, machine: { owner: :holder })
        .where.not(fixed_amount: nil)

      machine_results.find_each do |machine_result|
        amount = machine_result.fixed_amount.to_i
        next if amount.zero?

        worker = machine_result.machine.owner.holder
        next unless worker&.home&.member_flag?

        payment = payment_for_worker(batch, worker)
        append_detail(
          payment,
          payment_type: :machine_rental_fee,
          amount: amount,
          source: machine_result,
          source_label: "機械賃借料 #{machine_result.work.worked_at.strftime('%Y-%m-%d')}"
        )
      end
    end

    def payment_for_worker(batch, worker)
      payment = batch.zengin_payments.find_or_initialize_by(worker: worker)
      payment.assign_attributes(
        bank_code: worker.bank_code.to_s,
        branch_code: worker.branch_code.to_s,
        account_type_id: worker.account_type_id,
        account_number: worker.account_number.to_s,
        account_holder_name: worker.account_holder_name.to_s,
        amount: payment.amount.to_i
      )
      payment.save! if payment.new_record? || payment.changed?
      payment
    end

    def append_detail(payment, payment_type:, amount:, source:, source_label:)
      payment.zengin_payment_details.create!(
        payment_type: payment_type,
        source_kind: :generated,
        amount: amount,
        source_type: source.class.name,
        source_id: source.id,
        source_label: source_label
      )
      payment.update!(amount: payment.zengin_payment_details.sum(:amount))
    end
  end

end
