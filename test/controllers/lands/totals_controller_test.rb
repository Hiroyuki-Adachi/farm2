require "test_helper"
require "csv"

class Lands::TotalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "土地統計一覧(初期表示)" do
    get lands_totals_path
    assert_response :success
  end

  test "土地統計一覧(検証者以外)" do
    login_as(users(:user_user))
    get lands_totals_path
    assert_response :error
  end

  test "土地統計一覧(実行)" do
    get lands_totals_path, params: { work_kinds: [work_kinds(:work_kind_taue).id] }
    assert_response :success
  end

  test "CSVは土地IDに続いて画面と同じ項目と検索結果を出力する" do
    land = work_lands(:work_land_land_total_query).land
    land.update!(place: '地番,"テスト"')
    ids = [work_kinds(:work_kind_taue).id.to_s, work_kinds(:work_kind_shirokaki).id.to_s]
    params = { work_kinds: ["", *ids, ""] }

    get lands_totals_path, params: params

    assert_response :success
    assert_select 'a[href=?]', lands_totals_path(format: :csv, work_kinds: ids), text: 'CSV出力'
    table = response.parsed_body.at_css('#work_list')
    expected = table.css('tr').map { |row| row.css('th, td').map { |cell| cell.text.strip } }
    assert_operator expected.size, :>, 1

    get lands_totals_path(format: :csv), params: params

    assert_response :success
    assert_equal 'text/csv', response.media_type
    assert_includes response.headers['Content-Disposition'], 'attachment'
    assert_includes response.headers['Content-Disposition'], 'land_totals_2015.csv'
    rows = CSV.parse(response.body.dup.force_encoding(Encoding::Windows_31J).encode(Encoding::UTF_8))
    assert_equal '土地ID', rows.first.first
    assert_equal(expected, rows.map { |row| row.drop(1).map(&:to_s) })
    row = rows.drop(1).find { |values| values.first == land.id.to_s }
    assert_not_nil row
    assert_equal land.place, row[2]
    assert_nil row[6]
    assert_equal works(:works_land_total_query).worked_at.to_s, row[7]
    assert_not_includes rows.drop(1).map(&:first), lands(:land_other_org).id.to_s
  end

  test "地番・所有者・作付は常にダブルクォートで囲む" do
    land = work_lands(:work_land_land_total_query).land
    work_type = land_costs(:cost1).work_type

    get lands_totals_path(format: :csv), params: { work_kinds: [work_kinds(:work_kind_shirokaki).id] }

    assert_response :success
    body = response.body.dup.force_encoding(Encoding::Windows_31J).encode(Encoding::UTF_8)
    expected = %(#{land.id},#{land.parcel_number},"#{land.place}",#{land.area.to_f},) +
               %("#{land.owner.name}","#{work_type.name}",2015-01-05)
    assert_includes body, expected
  end

  test "作業種別を全枠選択してもCSVを出力できる" do
    ids = WorkKind.landable.usual.limit(4).pluck(:id)

    get lands_totals_path(format: :csv), params: { work_kinds: ids }

    assert_response :success
    rows = CSV.parse(response.body.dup.force_encoding(Encoding::Windows_31J).encode(Encoding::UTF_8))
    assert_equal ["土地ID", "耕地番号", "地番", "面積", "所有者", "作付", *ids.map { |id| WorkKind.find(id).name }], rows.first
  end

  test "作業種別未選択のCSVは見出しのみ出力する" do
    get lands_totals_path(format: :csv), params: { work_kinds: ["", "", "", ""] }

    assert_response :success
    rows = CSV.parse(response.body.dup.force_encoding(Encoding::Windows_31J).encode(Encoding::UTF_8))
    assert_equal [["土地ID", "耕地番号", "地番", "面積", "所有者", "作付"]], rows
  end

  test "検証者以外はCSVを出力できない" do
    login_as(users(:user_user))

    get lands_totals_path(format: :csv), params: { work_kinds: [work_kinds(:work_kind_taue).id] }

    assert_response :error
  end
end
