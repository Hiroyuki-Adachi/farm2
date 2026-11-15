require 'test_helper'

class MachineResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "機械結果一覧" do
    get machine_results_path
    assert_response :success

    get machine_results_path, params: { fixed_at: "2015-02-28" }
    assert_response :success
  end
  test "直接入力使用料は一覧とCSVで金額のみ表示する" do
    result = machine_results(:machine_results0)
    result.work.update!(fixed_at: Date.new(2015, 3, 31))
    result.update!(fixed_adjust_id: Adjust::AMOUNT.id, fixed_price: 0,
                   fixed_quantity: 0, fixed_amount: 9_999_999)
    # 表示対象を固定し、HTMLとCSVの同じレコードの出力を確認する。
    MachineResult.stubs(:by_home).returns([result])
    get machine_results_path
    assert_response :success
    assert_select "tr.tr-detail td.numeric", text: "9,999,999"
    assert_select "tr.tr-detail td:nth-child(6)", text: ""
    assert_select "tr.tr-detail td:nth-child(7)", text: ""
    assert_select "tr.tr-detail td:nth-child(8)", text: ""

    get machine_results_path(format: :csv)
    assert_response :success
    rows = CSV.parse(NKF.nkf('-w', response.body))
    assert_equal [nil, nil, nil], rows.last[5, 3]
    assert_equal BigDecimal("9999999"), BigDecimal(rows.last[8])
  end

end
