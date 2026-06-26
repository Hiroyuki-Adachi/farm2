require "csv"

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
  include ZenginAccount

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
  IMPORTED_PAYMENT_CSV_BASE_HEADERS = ["会計ID", "世帯名"].freeze
  IMPORTED_PAYMENT_CSV_OPTIONAL_HEADERS = ["備考"].freeze
  IMPORTED_PAYMENT_CSV_SAMPLE_HEADERS = ["農地管理料", "小作地管理料"].freeze
  IMPORTED_PAYMENT_CSV_HEADERS = [*IMPORTED_PAYMENT_CSV_BASE_HEADERS, *IMPORTED_PAYMENT_CSV_SAMPLE_HEADERS, *IMPORTED_PAYMENT_CSV_OPTIONAL_HEADERS].freeze
  ZENGIN_RECORD_BYTES = 120
  ZENGIN_ROW_SEPARATOR = "\r\n".encode("Windows-31J").freeze

  class ExportError < StandardError; end

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

  def self.land_fee_template_csv(organization)
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    homes = Home.for_organization(organization_id)
      .kept
      .joins(:section)
      .where(member_flag: true, sections: { work_flag: true })
      .includes(:holder)
      .to_a
      .sort_by { |home| [home.finance_order || 9999, home.id] }

    CSV.generate(row_sep: "\r\n") do |csv|
      csv << IMPORTED_PAYMENT_CSV_HEADERS
      homes.each do |home|
        csv << [home.finance_order, home.name, nil, nil, nil]
      end
    end
  end

  def import_land_fee_csv!(uploaded_file)
    result = self.class.parse_land_fee_csv(uploaded_file.read)
    rows = result[:rows]
    item_headers = result[:item_headers]
    totals_by_finance_order = Hash.new { |hash, key| hash[key] = Hash.new(0) }
    seen_finance_orders = Hash.new(0)
    homes_by_finance_order = Home.for_organization(organization_id).kept.joins(:section).where(member_flag: true, sections: { work_flag: true }).where.not(finance_order: nil).index_by(&:finance_order)

    rows.each do |row|
      line = row[:line]
      finance_order = row[:finance_order]
      home = homes_by_finance_order[finance_order]
      raise ActiveRecord::RecordInvalid, self.class.import_error(self, "#{line}行目: 会計ID #{finance_order} は全銀対象の組合員世帯に存在しません。") unless home

      seen_finance_orders[finance_order] += 1
      item_headers.each do |header|
        totals_by_finance_order[finance_order][header] += row[:amounts][header]
      end
    end

    transaction do
      replace_imported_land_fee_details!(totals_by_finance_order, homes_by_finance_order, item_headers)
    end

    imported_counts = item_headers.to_h do |header|
      [header, totals_by_finance_order.count { |_finance_order, totals| totals[header].to_i != 0 }]
    end
    duplicate_finance_orders = seen_finance_orders.select { |_finance_order, count| count > 1 }.keys

    {
      rows: rows.size,
      item_headers: item_headers,
      imported_counts: imported_counts,
      duplicate_finance_orders: duplicate_finance_orders
    }
  end

  def import_seedling_fee!(term:, seedling_price:)
    seedling_price = seedling_price.to_i
    seedling_homes = SeedlingHome.usual(term)
      .joins(home: :section)
      .where(homes: { organization_id: organization_id, member_flag: true }, sections: { work_flag: true })

    transaction do
      replace_generated_seedling_fee_details!(seedling_homes, seedling_price)
    end
  end

  def import_drying_adjustment_fee!(term:, system:)
    homes = Home.for_organization(organization_id)
      .for_drying
      .joins(:section)
      .where(member_flag: true, sections: { work_flag: true })
      .includes(:holder)

    transaction do
      replace_generated_drying_adjustment_fee_details!(homes, term, system)
    end
  end

  def update_manual_other_details!(payment_attributes)
    transaction do
      payment_attributes.each do |payment_id, attributes|
        payment = zengin_payments.includes(:zengin_payment_details).find_by(id: payment_id)
        next unless payment

        amount = self.class.parse_manual_amount(attributes[:manual_other_amount])
        remarks = attributes[:manual_other_remarks].to_s.presence
        detail = payment.zengin_payment_details.find_by(
          payment_type: :other,
          source_kind: :manual,
          source_label: "その他"
        )

        if amount.zero? && remarks.blank?
          next unless detail

          detail.destroy!
          payment.recalculate_amount!
          next
        end

        detail ||= payment.zengin_payment_details.build(
          payment_type: :other,
          source_kind: :manual,
          source_label: "その他",
          original_amount: 0
        )
        next if detail.amount.to_i == amount && detail.remarks.to_s == remarks.to_s

        detail.assign_attributes(amount: amount, remarks: remarks)
        detail.save!
        payment.recalculate_amount!
      end
    end
  end

  def move_details_to_worker!(details, target_worker)
    details = Array(details).compact
    return if details.empty?

    transaction do
      source_payments = details.map(&:zengin_payment).uniq
      target_payment = self.class.send(:payment_for_worker, self, target_worker)

      details.each do |detail|
        detail.update!(zengin_payment: target_payment)
      end

      (source_payments + [target_payment]).uniq.each do |payment|
        payment.reload
        if payment.zengin_payment_details.exists?
          payment.recalculate_amount!
        else
          payment.destroy!
        end
      end
    end
  end

def export_file!(transfer_on:)
  transfer_on = transfer_on.to_date
  errors = zengin_export_errors(transfer_on)
  raise ExportError, errors.join(" ") if errors.present?

  content = zengin_file_content(transfer_on)
  update!(exported_at: Time.current, status: :exported)
  content
end

  def zengin_export_errors(transfer_on)
    errors = []
    if transfer_on < Time.zone.today
      errors << "振込指定日は本日以降を指定してください。"
      return errors
    end

    errors << "委託者口座情報が未設定のため、全銀ファイルを出力できません。" if account_incomplete?

    incomplete_payments = []
    invalid_amount_payments = []
    export_payments.each do |payment|
      label = "#{payment.worker.home.name} #{payment.worker.name}"
      incomplete_payments << label if payment.account_incomplete?
      invalid_amount_payments << label if payment.amount.to_i <= 0
    end

    errors << export_payment_error_message("口座情報が未設定", incomplete_payments) if incomplete_payments.present?
    errors << export_payment_error_message("振込金額が0円以下", invalid_amount_payments) if invalid_amount_payments.present?

    errors
  end

  def export_payment_error_message(reason, labels)
    examples = labels.first(5).join("、")
    suffix = labels.size > 5 ? " ほか#{labels.size - 5}件" : ""
    "#{reason}の支払先が#{labels.size}件あるため、全銀ファイルを出力できません。#{examples}#{suffix}"
  end

  def account_incomplete?
    consignor_code.blank? || consignor_name.blank? || bank_account_incomplete?
  end

  def zengin_file_content(transfer_on)
    records = [zengin_header_record(transfer_on)]
    records.concat(export_payments.map { |payment| zengin_data_record(payment) })
    records << zengin_trailer_record
    records << zengin_end_record
    records.join(ZENGIN_ROW_SEPARATOR) + ZENGIN_ROW_SEPARATOR
  end

def export_payments
  @export_payments ||= zengin_payments
    .includes(worker: :home)
    .to_a
    .select { |payment| payment.worker.home.member_flag? }
    .sort_by { |payment| [payment.worker.home.finance_order || 9999, payment.worker.home.id, payment.worker.display_order || 9999, payment.worker.id] }
end

  def zengin_header_record(transfer_on)
    zengin_record(
      zengin_number(1, 1),
      zengin_number(21, 2),
      zengin_number(0, 1),
      zengin_number(consignor_code, 10),
      zengin_text(consignor_name, 40),
      zengin_number(transfer_on.strftime("%m%d"), 4),
      zengin_number(bank_code, 4),
      zengin_text("", 15),
      zengin_number(branch_code, 3),
      zengin_text("", 15),
      zengin_number(zengin_account_type(self), 1),
      zengin_number(account_number, 7),
      zengin_text("", 17)
    )
  end

  def zengin_data_record(payment)
    zengin_record(
      zengin_number(2, 1),
      zengin_number(payment.bank_code, 4),
      zengin_text("", 15),
      zengin_number(payment.branch_code, 3),
      zengin_text("", 15),
      zengin_number(0, 4),
      zengin_number(zengin_account_type(payment), 1),
      zengin_number(payment.account_number, 7),
      zengin_text(payment.account_holder_name, 30),
      zengin_number(payment.amount.to_i, 10),
      zengin_number(0, 1),
      zengin_number(0, 10),
      zengin_number(0, 10),
      zengin_number(7, 1),
      zengin_text("", 1),
      zengin_text("", 7)
    )
  end

  def zengin_trailer_record
    zengin_record(
      zengin_number(8, 1),
      zengin_number(export_payments.count, 6),
      zengin_number(export_payments.sum { |payment| payment.amount.to_i }, 12),
      zengin_text("", 101)
    )
  end

  def zengin_end_record
    zengin_record(
      zengin_number(9, 1),
      zengin_text("", 119)
    )
  end

  def zengin_record(*fields)
    record = fields.join
    raise ExportError, "全銀レコード長が不正です。" unless record.bytesize == ZENGIN_RECORD_BYTES

    record
  end

  def zengin_number(value, byte_size)
    value.to_i.to_s.rjust(byte_size, "0").last(byte_size).encode("Windows-31J")
  end

  def zengin_text(value, byte_size)
    buffer = +"".b
    value.to_s.each_char do |char|
      encoded = char.encode("Windows-31J", invalid: :replace, undef: :replace).b
      break if buffer.bytesize + encoded.bytesize > byte_size

      buffer << encoded
    end
    buffer << " ".b * (byte_size - buffer.bytesize)
    buffer.force_encoding("Windows-31J")
  end

  def zengin_account_type(record)
    record.account_type_id_before_type_cast.to_i
  end

  def self.parse_land_fee_csv(content)
    csv = CSV.parse(decode_land_fee_csv(content), headers: true)
    headers = csv.headers.compact.map { |header| header.to_s.strip }
    missing_headers = IMPORTED_PAYMENT_CSV_BASE_HEADERS - headers
    raise CSV::MalformedCSVError.new("CSVに必要な列がありません: #{missing_headers.join(', ')}", 1) if missing_headers.present?

    duplicate_headers = headers.tally.select { |_header, count| count > 1 }.keys
    raise CSV::MalformedCSVError.new("CSVの列名が重複しています: #{duplicate_headers.join(', ')}", 1) if duplicate_headers.present?

    item_headers = headers - IMPORTED_PAYMENT_CSV_BASE_HEADERS - IMPORTED_PAYMENT_CSV_OPTIONAL_HEADERS
    raise CSV::MalformedCSVError.new("取込項目の列がありません。", 1) if item_headers.blank?

    rows = csv.each_with_index.map do |row, index|
      {
        line: index + 2,
        finance_order: row["会計ID"].to_s.strip.to_i,
        amounts: item_headers.to_h { |header| [header, parse_land_fee_amount(row[header])] }
      }
    end

    { rows: rows, item_headers: item_headers }
  end

  def self.decode_land_fee_csv(content)
    text = content.to_s.dup
    utf8_text = text.dup.force_encoding("UTF-8")
    return utf8_text.delete_prefix("\uFEFF") if utf8_text.valid_encoding?

    text.force_encoding("Windows-31J").encode("UTF-8", invalid: :replace, undef: :replace).delete_prefix("\uFEFF")
  end

  def self.parse_land_fee_amount(value)
    text = value.to_s.strip.delete(",")
    return 0 if text.blank?

    Integer(text, 10)
  rescue ArgumentError
    0
  end

  def self.parse_manual_amount(value)
    parse_land_fee_amount(value)
  end

  def self.import_error(batch, message)
    batch.errors.add(:base, message)
    batch
  end

  def replace_imported_land_fee_details!(totals_by_finance_order, homes_by_finance_order, item_headers)
    payment_type_value = ZenginPaymentDetail.payment_types.fetch("other")
    payments = zengin_payments.includes(:zengin_payment_details).to_a
    target_payments = payments.select do |payment|
      payment.zengin_payment_details.any? { |detail| detail.source_kind_imported? }
    end

    target_payments.each do |payment|
      payment.zengin_payment_details.where(source_kind: :imported).destroy_all
    end

    totals_by_finance_order.each do |finance_order, totals|
      worker = homes_by_finance_order.fetch(finance_order).holder
      next unless worker

      payment = self.class.send(:payment_for_worker, self, worker)
      item_headers.each do |header|
        amount = totals[header].to_i
        next if amount.zero?

        payment.zengin_payment_details.create!(
          payment_type: payment_type_value,
          source_kind: :imported,
          amount: amount,
          original_amount: amount,
          source_type: self.class.name,
          source_id: id,
          source_label: header
        )
      end
    end

    (target_payments + zengin_payments.reload.to_a).uniq.each do |payment|
      amount = payment.zengin_payment_details.sum(:amount)
      amount.zero? ? payment.destroy! : payment.update!(amount: amount)
    end
  end

  def replace_generated_seedling_fee_details!(seedling_homes, seedling_price)
    payment_type_value = ZenginPaymentDetail.payment_types.fetch("seedling_fee")
    payments = zengin_payments.includes(:zengin_payment_details).to_a
    target_payments = payments.select do |payment|
      payment.zengin_payment_details.any? { |detail| detail.source_kind_generated? && ZenginPaymentDetail.payment_types.fetch(detail.payment_type) == payment_type_value }
    end

    target_payments.each do |payment|
      payment.zengin_payment_details
        .where(source_kind: :generated, payment_type: payment_type_value)
        .destroy_all
    end

    count = 0
    total_amount = 0
    seedling_homes.each do |seedling_home|
      amount = seedling_home.cost_quantity.to_i * seedling_price
      next if amount.zero?

      worker = seedling_home.home.holder
      next unless worker

      payment = self.class.send(:payment_for_worker, self, worker)
      payment.zengin_payment_details.create!(
        payment_type: :seedling_fee,
        source_kind: :generated,
        amount: amount,
        original_amount: amount,
        source_type: seedling_home.class.name,
        source_id: seedling_home.id,
        source_label: "育苗費 #{seedling_home.work_type_name}"
      )
      count += 1
      total_amount += amount
    end

    (target_payments + zengin_payments.reload.to_a).uniq.each do |payment|
      amount = payment.zengin_payment_details.sum(:amount)
      amount.zero? ? payment.destroy! : payment.update!(amount: amount)
    end

    { count: count, amount: total_amount }
  end

  def replace_generated_drying_adjustment_fee_details!(homes, term, system)
    payment_type_value = ZenginPaymentDetail.payment_types.fetch("drying_adjustment_fee")
    payments = zengin_payments.includes(:zengin_payment_details).to_a
    target_payments = payments.select do |payment|
      payment.zengin_payment_details.any? { |detail| detail.source_kind_generated? && ZenginPaymentDetail.payment_types.fetch(detail.payment_type) == payment_type_value }
    end

    target_payments.each do |payment|
      payment.zengin_payment_details
        .where(source_kind: :generated, payment_type: payment_type_value)
        .destroy_all
    end

    count = 0
    total_amount = 0
    homes.each do |home|
      worker = home.holder
      next unless worker

      Drying.by_home(term, home).includes(:work_type, :drying_moths, :adjustment).each do |drying|
        amount = drying.total_amount(system, home.id).to_i
        next if amount.zero?

        payment = self.class.send(:payment_for_worker, self, worker)
        payment.zengin_payment_details.create!(
          payment_type: :drying_adjustment_fee,
          source_kind: :generated,
          amount: amount,
          original_amount: amount,
          source_type: drying.class.name,
          source_id: drying.id,
          source_label: "乾燥調整費 #{drying.work_type&.name} #{drying.carried_on.strftime('%Y-%m-%d')}"
        )
        count += 1
        total_amount += amount
      end
    end

    (target_payments + zengin_payments.reload.to_a).uniq.each do |payment|
      amount = payment.zengin_payment_details.sum(:amount)
      amount.zero? ? payment.destroy! : payment.update!(amount: amount)
    end

    { count: count, amount: total_amount }
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
        original_amount: amount,
        source_type: source.class.name,
        source_id: source.id,
        source_label: source_label
      )
      payment.update!(amount: payment.zengin_payment_details.sum(:amount))
    end
  end

end
