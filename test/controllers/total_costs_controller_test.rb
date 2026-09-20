require 'test_helper'
require 'csv'

class TotalCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    ["水稲", "麦"].each do |name|
      work_type = WorkType.create!(name: name, genre: work_genres(:genre_change), cost_flag: true)
      work_type.work_type_terms.create!(term: @user.term)
    end
  end

  test "原価一覧" do
    get total_costs_path
    assert_response :success
  end

  test "CSVは画面と同じ順序と金額で出力する" do
    work_type = WorkType.cost.by_term(@user.term).first!
    cost_type = cost_types(:cost_types1)
    cost_type.update!(name: '費用,"内訳"')
    create_csv_cost(work_type, cost_type, 12_345)
    create_csv_cost(work_type, cost_type, 99_999, organization_id: organizations(:org2).id)
    create_csv_cost(work_type, cost_type, 88_888, term: @user.term - 1)

    get total_costs_path
    assert_select 'a[href=?]', total_costs_path(format: :csv), text: 'CSV出力'
    table = response.parsed_body.at_css('#tbl_list')
    expected = table.css('tr').map { |row| row.css('th, td').map { |cell| cell.text.strip } }
    expected[0][0] = '原価種別'
    expected.drop(1).each { |row| row[1..].each_with_index { |value, i| row[i + 1] = value.delete(',') } }

    get total_costs_path(format: :csv)

    assert_response :success
    assert_equal 'text/csv', response.media_type
    assert_includes response.headers['Content-Disposition'], 'attachment'
    assert_includes response.headers['Content-Disposition'], 'total_costs_2015.csv'
    rows = CSV.parse(response.body.dup.force_encoding(Encoding::SJIS).encode(Encoding::UTF_8))
    assert_equal expected, rows
    assert_includes rows.flatten, '12345'
    assert_not_includes rows.flatten, '99999'
    assert_not_includes rows.flatten, '88888'
    assert_includes rows.flatten, '0'
  end

  test "未計算でもCSVを出力できる" do
    get total_costs_path(format: :csv)

    assert_response :success
    rows = CSV.parse(response.body.dup.force_encoding(Encoding::SJIS).encode(Encoding::UTF_8))
    assert_equal '原価種別', rows.first.first
    assert(rows.drop(1).flat_map { |row| row.drop(1) }.all?('0'))
  end

  test "原価種別未設定ならCSVではなくエラー画面へ誘導する" do
    TotalCost.create!(organization_id: @user.organization_id, term: @user.term,
                      total_cost_type_id: TotalCostType::WORKWORKER.id,
                      occurred_on: '2015-02-01', amount: 100)

    get total_costs_path(format: :csv)

    assert_redirected_to total_costs_path
    follow_redirect!
    assert_response :success
    assert_select 'h1', '原価区分別原価エラー'
  end

  test "管理者以外はCSVを出力できない" do
    login_as(users(:user_checker))

    get total_costs_path(format: :csv)

    assert_response :error
  end

  test "未計算時は最大の締め月を選択する" do
    Fix.create!(fixes(:fix1).attributes.merge("fixed_at" => Date.new(2015, 3, 31)))

    get total_costs_path

    assert_select 'select[name="fixed_on"] option[selected]', count: 1 do
      assert_select '[value="2015-03-31"]'
    end
  end

  test "表示中の原価を計算した締め月を選択する" do
    Fix.create!(fixes(:fix1).attributes.merge("fixed_at" => Date.new(2015, 3, 31)))
    systems(:s2015).update!(total_cost_fixed_on: Date.new(2015, 2, 28))
    systems(:s2017).update!(total_cost_fixed_on: Date.new(2017, 12, 31))
    systems(:s2015_org2).update!(total_cost_fixed_on: Date.new(2015, 3, 31))

    get total_costs_path

    assert_select 'select[name="fixed_on"] option[selected]', count: 1 do
      assert_select '[value="2015-02-28"]'
    end
  end

  test "締め月がない場合も表示できる" do
    Fix.where(organization_id: @user.organization_id, term: @user.term).delete_all

    get total_costs_path

    assert_response :success
    assert_select 'select[name="fixed_on"] option', count: 0
  end

  test "原価を削除したら締め月の記録も消す" do
    systems(:s2015).update!(total_cost_fixed_on: Date.new(2015, 2, 28))

    delete total_cost_path(1)

    assert_redirected_to total_costs_path
    assert_nil systems(:s2015).reload.total_cost_fixed_on
  end

  test "原価一覧(管理者以外)" do
    login_as(users(:user_checker))
    get total_costs_path
    assert_response :error
  end

  test "原価計算" do
    assert_enqueued_with(job: TotalCostsMakeJob) do
      post total_costs_path, params: { fixed_on: "2015-12-31" }
    end
    assert_redirected_to total_costs_path
  end

  private

  def create_csv_cost(work_type, cost_type, amount, organization_id: @user.organization_id, term: @user.term)
    total_cost = TotalCost.create!(organization_id: organization_id, term: term,
                                   total_cost_type_id: TotalCostType::WORKWORKER.id,
                                   cost_type_id: cost_type.id, occurred_on: '2015-02-01', amount: amount)
    total_cost.total_cost_details.create!(work_type_id: work_type.id, area: 1, cost: amount)
  end
end
