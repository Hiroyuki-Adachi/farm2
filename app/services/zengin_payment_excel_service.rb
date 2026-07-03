require "rubyXL"
require "rubyXL/convenience_methods"

class ZenginPaymentExcelService
  include Workbook

  TEMPLATE_PATH = Rails.root.join("app/views/zengin_payments/excels/zengin_results.xlsx")
  PAYMENT_TYPE_LABELS = {
    "daily_wage" => "日当",
    "land_management_fee" => "農地管理料",
    "tenant_land_management_fee" => "小作地管理料",
    "machine_rental_fee" => "機械賃借料",
    "seedling_fee" => "育苗費",
    "drying_adjustment_fee" => "乾燥調整費",
    "other" => "その他"
  }.freeze
  ITEM_COLUMN_OFFSET = 6

  def self.call(batch)
    new(batch).call
  end

  def initialize(batch)
    @batch = batch
  end

  def call
    workbook = parse_workbook(TEMPLATE_PATH)
    setup_workbook(workbook)
    @template_sheet = find_template_sheet(workbook)
    generated_sheets = details_by_payment_type.map do |payment_type, details|
      build_sheet(workbook, payment_type, details)
    end
    if generated_sheets.empty?
      sheet = workbook.add_worksheet("支払結果(#{@batch.fixed_at.month}月)")
      copy_sheet_layout(@template_sheet, sheet)
      generated_sheets << sheet
    end

    workbook.worksheets = generated_sheets
    workbook.stream.read
  end

  private

  def details_by_payment_type
    payments
      .flat_map(&:zengin_payment_details)
      .group_by(&:payment_type)
      .sort_by { |payment_type, _| ZenginPaymentDetail.payment_types.fetch(payment_type) }
  end

  def payments
    @payments ||= @batch.zengin_payments
      .joins(worker: { home: :section })
      .includes(:zengin_payment_details, worker: { home: :section })
      .where(homes: { member_flag: true })
      .order(
        Arel.sql(
          "homes.finance_order ASC NULLS LAST, homes.id ASC, " \
          "workers.display_order ASC NULLS LAST, workers.id ASC"
        )
      )
      .to_a
  end

  def find_template_sheet(workbook)
    named_template = workbook["(Template)"]
    return named_template if template_row?(named_template)

    workbook.worksheets.find { |sheet| sheet.sheet_data.rows.compact.any? } ||
      raise("Excelテンプレートの行が見つかりません。")
  end

  def template_row?(sheet)
    sheet && sheet.sheet_data.rows.compact.any?
  end

  def build_sheet(workbook, payment_type, details)
    sheet = workbook.add_worksheet(sheet_name(payment_type))
    copy_sheet_layout(@template_sheet, sheet)
    details_by_payment = details.group_by(&:zengin_payment_id)
    target_payments = payments.select { |payment| details_by_payment.key?(payment.id) }
    work_results = daily_work_results(details)
    payment_rows = target_payments.map do |payment|
      [payment, payment_items(payment_type, details_by_payment.fetch(payment.id), work_results)]
    end
    prepare_item_columns(sheet, payment_rows.map { |_payment, items| items.size }.max || 1)

    payment_rows.each_with_index do |(payment, items), row_index|
      fill_row(sheet, row_index + 1, payment, items)
    end

    sheet
  end

  def sheet_name(payment_type)
    "#{PAYMENT_TYPE_LABELS.fetch(payment_type, payment_type)}(#{@batch.fixed_at.month}月)"
  end

  def copy_sheet_layout(source, target)
    target.sheet_format_pr = deep_copy(source.sheet_format_pr)
    target.page_margins = deep_copy(source.page_margins)
    target.page_setup = deep_copy(source.page_setup)
    target.print_options = deep_copy(source.print_options)

    target.cols = deep_copy(source.cols)
    copy_template_rows(source, target)
  end

  def copy_template_rows(source, target)
    source.sheet_data.rows.each_with_index do |source_row, row_index|
      next unless source_row

      source_row.cells.each_with_index do |source_cell, column_index|
        next unless source_cell

        formula = source_cell.formula&.expression
        target_cell = target.add_cell(row_index, column_index, source_cell.value, formula)
        target_cell.style_index = source_cell.style_index
      end
    end
  end

  def prepare_item_columns(sheet, item_count)
    2.upto(item_count) do |item_number|
      copy_item_column(sheet, ITEM_COLUMN_OFFSET, item_name_column(item_number), item_number)
      copy_item_column(sheet, ITEM_COLUMN_OFFSET + 1, item_amount_column(item_number), item_number)
    end
  end

  def copy_item_column(sheet, source_column, target_column, item_number)
    column_range = deep_copy(@template_sheet.cols.locate_range(source_column))
    column_range.min = target_column + 1
    column_range.max = target_column + 1
    sheet.cols << column_range

    source_cell = @template_sheet[0][source_column]
    header_value = source_cell.value.to_s.sub(/\d+\z/, item_number.to_s)
    target_cell = sheet.add_cell(0, target_column, header_value, source_cell.formula&.expression)
    target_cell.style_index = source_cell.style_index
  end

  def item_name_column(item_number)
    ITEM_COLUMN_OFFSET + ((item_number - 1) * 2)
  end

  def item_amount_column(item_number)
    item_name_column(item_number) + 1
  end

  def deep_copy(value)
    value && Marshal.load(Marshal.dump(value))
  end

  def daily_work_results(details)
    ids = details.filter_map do |detail|
      detail.source_id if detail.payment_type_daily_wage? && detail.source_type == "WorkResult"
    end.uniq
    WorkResult.includes(:worker).where(id: ids).index_by(&:id)
  end

  def payment_items(payment_type, details, work_results)
    if payment_type == "daily_wage"
      daily_wage_items(details, work_results)
    else
      details
        .group_by { |detail| payment_item_label(payment_type, detail) }
        .map { |label, grouped_details| [label, grouped_details.sum { |detail| detail.amount.to_i }] }
    end
  end

  def payment_item_label(payment_type, detail)
    detail.display_source_label.presence || PAYMENT_TYPE_LABELS.fetch(payment_type, payment_type)
  end

  def daily_wage_items(details, work_results)
    grouped_details = details.group_by { |detail| daily_wage_key(detail, work_results) }
    ordered_groups = grouped_details.sort_by { |_key, group| daily_wage_order(group.first, work_results) }
    ordered_groups.map do |_key, group|
      [daily_wage_label(group.first, work_results), group.sum { |detail| detail.amount.to_i }]
    end
  end

  def daily_wage_order(detail, work_results)
    worker = work_results[detail.source_id]&.worker
    [worker&.display_order || Float::INFINITY, worker&.id || Float::INFINITY, detail.id]
  end

  def daily_wage_key(detail, work_results)
    work_results[detail.source_id]&.worker_id || detail.display_source_label.presence || detail.id
  end

  def daily_wage_label(detail, work_results)
    work_result = work_results[detail.source_id]
    return WorkerDecorator.decorate(work_result.worker).name if work_result

    detail.display_source_label.presence || "日当"
  end

  def fill_row(sheet, row_index, payment, items)
    fill_payment_cells(sheet, row_index, payment)
    amount_columns = fill_item_cells(sheet, row_index, items)
    fill_total_cell(sheet, row_index, items, amount_columns)
  end

  def fill_payment_cells(sheet, row_index, payment)
    home = payment.worker.home
    set_cell(sheet, row_index, 0, row_index)
    set_cell(sheet, row_index, 1, home.section&.name.to_s)
    set_cell(sheet, row_index, 2, home.finance_order.to_s.chars.join("-"))
    set_cell(sheet, row_index, 3, home.name)
    set_cell(sheet, row_index, 4, WorkerDecorator.decorate(payment.worker).name)
  end

  def fill_item_cells(sheet, row_index, items)
    items.each_with_index.map do |(label, amount), item_index|
      label_column = ITEM_COLUMN_OFFSET + (item_index * 2)
      amount_column = label_column + 1
      set_cell(sheet, row_index, label_column, label)
      set_cell(sheet, row_index, amount_column, amount)
      RubyXL::Reference.ind2ref(row_index, amount_column)
    end
  end

  def fill_total_cell(sheet, row_index, items, amount_columns)
    total_cell = set_cell(sheet, row_index, 5, items.sum(&:last))
    total_cell.formula = RubyXL::Formula.new(expression: "SUM(#{amount_columns.join(',')})")
  end

  def set_cell(sheet, row_index, column_index, value)
    cell = sheet[row_index]&.[](column_index) || sheet.add_cell(row_index, column_index)
    cell.change_contents(value)
    cell
  end
end
