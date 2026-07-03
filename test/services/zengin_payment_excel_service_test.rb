require "test_helper"

class ZenginPaymentExcelServiceTest < ActiveSupport::TestCase
  include Workbook

  test "支払種別ごとのシートへ支払結果を出力する" do
    home = homes(:home1)
    home.update!(finance_order: 12)
    batch = ZenginPaymentBatch.create!(
      organization: organizations(:org),
      term: 2015,
      fixed_at: Date.new(2015, 2, 28)
    )
    payment = batch.zengin_payments.create!(
      worker: workers(:worker1),
      amount: 4_500
    )
    first_work_result = work_results(:work_results1)
    second_work_result = work_results(:work_results3)
    last_work_result = work_results(:work_results0)
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 400,
      original_amount: 400,
      source_type: "WorkResult",
      source_id: last_work_result.id,
      source_label: "日当 2015-01-03"
    )
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 500,
      original_amount: 500,
      source_type: "WorkResult",
      source_id: second_work_result.id,
      source_label: "日当 2015-01-04"
    )
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 1_000,
      original_amount: 1_000,
      source_type: "WorkResult",
      source_id: first_work_result.id,
      source_label: "日当 2015-01-05"
    )
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 2_000,
      original_amount: 2_000,
      source_type: "WorkResult",
      source_id: first_work_result.id,
      source_label: "日当 2015-01-06"
    )
    payment.zengin_payment_details.create!(
      payment_type: :other,
      source_kind: :manual,
      amount: 1_500,
      original_amount: 1_500,
      source_label: "調整金"
    )
    payment.zengin_payment_details.create!(
      payment_type: :seedling_fee,
      source_kind: :generated,
      amount: 500,
      original_amount: 500,
      source_label: "育苗費 コシヒカリ"
    )

    workbook = parse_workbook_buffer(ZenginPaymentExcelService.call(batch))
    daily_sheet = workbook["日当(2月)"]
    seedling_sheet = workbook["育苗費(2月)"]
    other_sheet = workbook["その他(2月)"]

    assert_equal ["日当(2月)", "育苗費(2月)", "その他(2月)"], workbook.worksheets.map(&:sheet_name)
    assert_equal "No.", daily_sheet[0][0].value
    assert_equal ["明細名1", "明細金額1", "明細名2", "明細金額2", "明細名3", "明細金額3"],
                 daily_sheet[0].cells[6..11].map(&:value)
    assert_equal daily_sheet[0][6].style_index, daily_sheet[0][8].style_index
    assert_equal daily_sheet[0][6].style_index, daily_sheet[0][10].style_index
    assert_equal daily_sheet[0][7].style_index, daily_sheet[0][9].style_index
    assert_equal daily_sheet[0][7].style_index, daily_sheet[0][11].style_index
    assert_equal daily_sheet.get_column_width_raw(6), daily_sheet.get_column_width_raw(8)
    assert_equal daily_sheet.get_column_width_raw(6), daily_sheet.get_column_width_raw(10)
    assert_equal daily_sheet.get_column_width_raw(7), daily_sheet.get_column_width_raw(9)
    assert_equal daily_sheet.get_column_width_raw(7), daily_sheet.get_column_width_raw(11)
    assert_nil seedling_sheet[0][8]
    assert_nil other_sheet[0][8]
    refute_equal daily_sheet[0][0].style_index, daily_sheet[1][0].style_index
    refute_equal daily_sheet[0][6].style_index, daily_sheet[1][6].style_index
    assert_equal 1, daily_sheet[1][0].value
    assert_equal home.section.name, daily_sheet[1][1].value
    assert_equal "1-2", daily_sheet[1][2].value
    assert_equal home.name, daily_sheet[1][3].value
    assert_equal WorkerDecorator.decorate(payment.worker).name, daily_sheet[1][4].value
    assert_equal 3_900, daily_sheet[1][5].value
    assert_equal "SUM(H2,J2,L2)", daily_sheet[1][5].formula.expression
    assert_equal WorkerDecorator.decorate(first_work_result.worker).name, daily_sheet[1][6].value
    assert_equal 3_000, daily_sheet[1][7].value
    assert_equal WorkerDecorator.decorate(second_work_result.worker).name, daily_sheet[1][8].value
    assert_equal 500, daily_sheet[1][9].value
    assert_equal WorkerDecorator.decorate(last_work_result.worker).name, daily_sheet[1][10].value
    assert_equal 400, daily_sheet[1][11].value
    assert_equal "コシヒカリ", seedling_sheet[1][6].value
    assert_equal "調整金", other_sheet[1][6].value
    assert_equal 1_500, other_sheet[1][7].value
  end
end
