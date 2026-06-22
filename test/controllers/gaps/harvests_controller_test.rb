require "test_helper"

class Gaps::HarvestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP収穫一覧(一覧)" do
    get gaps_harvests_path

    assert_response :success
  end

  test "GAP収穫一覧は選択した作業分類と収穫作業種別で絞り込む" do
    harvest_work = create_harvest_work(work_type: work_types(:work_type_broccoli), worked_at: Date.new(2015, 6, 10), remarks: "収穫一覧テスト")
    create_harvest_work(work_type: work_types(:work_type_koshi), worked_at: Date.new(2015, 6, 11), remarks: "別作業分類")
    create_harvest_work(work_type: work_types(:work_type_broccoli), work_kind: work_kinds(:work_kind_taue), worked_at: Date.new(2015, 6, 12), remarks: "別作業種別")
    WorkLand.create!(work: harvest_work, land: lands(:lands1), display_order: 1)

    get gaps_harvests_path, params: { work_type_id: work_types(:work_type_broccoli).id, worked_at: Date.new(2015, 6, 1) }

    assert_response :success
    assert_includes @response.body, "収穫一覧テスト"
    assert_includes @response.body, land_term_marks(:land_term_mark1).mark
    assert_no_match "別作業分類", @response.body
    assert_no_match "別作業種別", @response.body
  end

  test "GAP収穫一覧の年月候補は収穫作業種別だけ表示する" do
    create_harvest_work(work_type: work_types(:work_type_broccoli), worked_at: Date.new(2015, 7, 10))
    create_harvest_work(work_type: work_types(:work_type_broccoli), work_kind: work_kinds(:work_kind_taue), worked_at: Date.new(2015, 8, 10))

    get months_gaps_harvest_path(work_types(:work_type_broccoli).id)

    assert_response :success
    assert_includes @response.body, "2015年 07月"
    assert_no_match "2015年 08月", @response.body
  end

  private

  def create_harvest_work(work_type:, worked_at:, remarks: "", work_kind: organizations(:org).broccoli_work_kind)
    Work.create!(
      organization: organizations(:org),
      term: users(:users1).term,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type: work_type,
      work_kind: work_kind,
      name: "収穫一覧テスト作業",
      remarks: remarks,
      start_at: "08:00",
      end_at: "12:00",
      created_by: workers(:worker1).id
    )
  end
end
