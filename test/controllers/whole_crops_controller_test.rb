require 'test_helper'

class WholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "WCS一覧" do
    work_whole_crop = work_whole_crops(:whole_crop1)
    system = systems(:s2015)

    assert_no_difference('WorkWholeCrop.count') do
      get whole_crops_path
    end
    assert_response :success

    work_whole_crop.reload
    assert_equal work_whole_crop.unit_price, system.roll_price
  end

  test "WCS一覧に他組織の作業を表示せず単価も更新しない" do
    works(:work_other_org).update!(worked_at: Date.new(2015, 12, 31))
    other_whole_crop = WorkWholeCrop.create!(
      work: works(:work_other_org),
      article_name: "別組織WCS",
      unit_price: 99,
      tax_rate: 8
    )

    get whole_crops_path

    assert_response :success
    assert_not_includes response.body, "2015-12-31"
    assert_equal 99, other_whole_crop.reload.unit_price
  end

  test "WCS一覧(管理者以外)" do
    login_as(users(:user_checker))
    get whole_crops_path
    assert_response :error
  end

  test "WCS未登録の作業も警告表示し期間と品種の選択肢に含める" do
    work = works(:work_wcs)
    work.update!(work_kind_id: organizations(:org).whole_crop_work_kind_id, worked_at: Date.new(2015, 12, 31))

    assert_no_difference('WorkWholeCrop.count') { get whole_crops_path }

    assert_response :success
    assert_select 'tbody tr', text: /2015-12-31/ do
      assert_select 'input.wcs-row-checkbox[disabled]', count: 1
      assert_select 'td.text-danger', count: 6
      assert_select 'td.numeric.text-danger', text: '-', count: 4
    end
    assert_select 'input.worked-month-filter[data-ym="2015-12"]'
    assert_select "input.work-type-filter[data-work-type-id='#{work.work_type_id}']"
  end

  test "正常な収穫行は選択できCSV出力される" do
    crop = prepare_crop
    get whole_crops_path
    assert_select "input.wcs-row-checkbox[value='#{crop.id}']:not([disabled])", count: 1

    get whole_crops_path(format: :csv), params: { ids: [crop.id] }
    assert_equal 2, CSV.parse(response.body.encode(Encoding::UTF_8)).size
  end

  test "数量ゼロでも重量は保持し警告行をCSVから除外する" do
    crop = prepare_crop
    crop.wcs_lands.each { |land| land.update!(rolls: 0) }
    crop.wcs_rolls.each { |roll| roll.update!(weight: 300) }

    assert_warning_crop(crop, '300', '0')
  end

  test "重量ゼロでも数量は保持し警告行をCSVから除外する" do
    crop = prepare_crop
    crop.wcs_rolls.each { |roll| roll.update!(weight: 0) }

    assert_warning_crop(crop, '0', '45')
  end

  test "CSVは別組織と別年度と別作業種別の指定IDを除外する" do
    crop = prepare_crop
    excluded_attributes = [
      { organization_id: works(:work_other_org).organization_id }, { term: 2014 }, { work_kind_id: 23 }
    ]
    excluded_attributes.each do |attributes|
      crop.work.update!(attributes)
      get whole_crops_path(format: :csv), params: { ids: [crop.id] }
      assert_equal 1, CSV.parse(response.body.encode(Encoding::UTF_8)).size
      crop.work.update!(organization_id: organizations(:org).id, term: 2015,
                        work_kind_id: organizations(:org).whole_crop_work_kind_id)
    end
  end

  private

  def prepare_crop
    crop = work_whole_crops(:whole_crop1)
    crop.work.update!(work_kind_id: organizations(:org).whole_crop_work_kind_id)
    crop
  end

  def assert_warning_crop(crop, weight, rolls)
    get whole_crops_path
    assert_response :success
    assert_select 'tbody tr', text: /2015-03-25/ do
      assert_select "input.wcs-row-checkbox[value='#{crop.id}'][disabled]", count: 1
      assert_select 'td.text-danger', count: 6
      assert_select 'td:nth-child(4)', text: weight
      assert_select 'td:nth-child(5)', text: rolls
      assert_select 'td:nth-child(6)', text: systems(:s2015).roll_price.to_s
      assert_select 'td:nth-child(7)', text: '0'
    end

    get whole_crops_path(format: :csv), params: { ids: [crop.id] }
    assert_response :success
    assert_equal 1, CSV.parse(response.body.encode(Encoding::UTF_8)).size
  end
end
