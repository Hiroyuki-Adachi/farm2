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
    work_result = work_results(:work_results1)
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 1_000,
      original_amount: 1_000,
      source_type: "WorkResult",
      source_id: work_result.id,
      source_label: "日当 2015-01-05"
    )
    payment.zengin_payment_details.create!(
      payment_type: :daily_wage,
      source_kind: :generated,
      amount: 2_000,
      original_amount: 2_000,
      source_type: "WorkResult",
      source_id: work_result.id,
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
    assert_equal 1, daily_sheet[1][0].value
    assert_equal home.section.name, daily_sheet[1][1].value
    assert_equal "1-2", daily_sheet[1][2].value
    assert_equal home.name, daily_sheet[1][3].value
    assert_equal WorkerDecorator.decorate(payment.worker).name, daily_sheet[1][4].value
    assert_equal 3_000, daily_sheet[1][5].value
    assert_equal "SUM(H2)", daily_sheet[1][5].formula.expression
    assert_equal WorkerDecorator.decorate(work_result.worker).name, daily_sheet[1][6].value
    assert_equal 3_000, daily_sheet[1][7].value
    assert_equal "コシヒカリ", seedling_sheet[1][6].value
    assert_equal "調整金", other_sheet[1][6].value
    assert_equal 1_500, other_sheet[1][7].value
  end
end
