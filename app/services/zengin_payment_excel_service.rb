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
  TEMPLATE_ITEM_PAIRS = 7

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
      .includes(:zengin_payment_details, worker: { home: :section })
      .select { |payment| payment.worker.home.member_flag? }
      .sort_by do |payment|
        home = payment.worker.home
        [
          home.finance_order || Float::INFINITY,
          home.id,
          payment.worker.display_order || Float::INFINITY,
          payment.worker.id
        ]
      end
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
    @template_styles = @template_sheet[0].cells.map { |cell| cell&.style_index || 0 }
    details_by_payment = details.group_by(&:zengin_payment_id)
    target_payments = payments.select { |payment| details_by_payment.key?(payment.id) }
    work_results = daily_work_results(details)

    target_payments.each_with_index do |payment, row_index|
      items = payment_items(payment_type, details_by_payment.fetch(payment.id), work_results)
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

    copy_template_row(source, target)
    copy_column_widths(source, target)
  end

  def copy_template_row(source, target)
    source[0].cells.each_with_index do |source_cell, column_index|
      next unless source_cell

      formula = source_cell.formula&.expression
      target_cell = target.add_cell(0, column_index, source_cell.value, formula)
      target_cell.style_index = source_cell.style_index
    end
  end

  def copy_column_widths(source, target)
    source[0].cells.size.times do |column_index|
      width = source.get_column_width_raw(column_index)
      target.change_column_width_raw(column_index, width) if width
    end
  end

  def deep_copy(value)
    value && Marshal.load(Marshal.dump(value))
  end

  def daily_work_results(details)
    ids = details.filter_map do |detail|
      detail.source_id if detail.payment_type_daily_wage? && detail.source_type == "WorkResult"
    end
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
    label = detail.source_label.presence || PAYMENT_TYPE_LABELS.fetch(payment_type, payment_type)
    return label unless payment_type == "seedling_fee"

    label.sub(/\A育苗費\s*/, "")
  end

  def daily_wage_items(details, work_results)
    grouped_details = details.group_by { |detail| daily_wage_key(detail, work_results) }
    grouped_details.map do |_key, group|
      [daily_wage_label(group.first, work_results), group.sum { |detail| detail.amount.to_i }]
    end
  end

  def daily_wage_key(detail, work_results)
    work_results[detail.source_id]&.worker_id || detail.source_label.presence || detail.id
  end

  def daily_wage_label(detail, work_results)
    work_result = work_results[detail.source_id]
    return WorkerDecorator.decorate(work_result.worker).name if work_result

    detail.source_label.presence || "日当"
  end

  def fill_row(sheet, row_index, payment, items)
    required_pairs = [items.size, TEMPLATE_ITEM_PAIRS].max
    last_column = ITEM_COLUMN_OFFSET + (required_pairs * 2)
    copy_row_styles(sheet, row_index, last_column)
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

  def copy_row_styles(sheet, row_index, last_column)
    (0..last_column).each do |column_index|
      template_column = template_style_column(column_index, @template_styles.size, last_column)
      cell = set_cell(sheet, row_index, column_index, nil)
      cell.style_index = @template_styles.fetch(template_column, 0)

      width = @template_sheet.get_column_width_raw(template_column)
      sheet.change_column_width_raw(column_index, width) if width
    end
  end

  def template_style_column(column_index, template_column_count, last_column)
    terminator_column = template_column_count - 1
    return column_index if column_index < terminator_column
    return terminator_column if column_index == last_column
    return terminator_column - 2 if column_index.even?

    terminator_column - 1
  end

  def set_cell(sheet, row_index, column_index, value)
    cell = sheet[row_index]&.[](column_index) || sheet.add_cell(row_index, column_index)
    cell.change_contents(value)
    cell
  end
end
