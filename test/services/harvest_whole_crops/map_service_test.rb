require "test_helper"

class HarvestWholeCrops::MapServiceTest < ActiveSupport::TestCase
  test "同一日報内の圃場は面積按分した同じ10a換算値になる" do
    work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    land1 = create_land(place: "A-1", area: 10)
    land2 = create_land(place: "A-2", area: 30)

    work_land1 = WorkLand.create!(work: work, land: land1, work_type_id: 15)
    work_land2 = WorkLand.create!(work: work, land: land2, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: work.whole_crop, work_land: work_land1, rolls: 5)
    WholeCropLand.create!(work_whole_crop: work.whole_crop, work_land: work_land2, rolls: 35)

    summaries = HarvestWholeCrops::MapService.call(organization: organizations(:org), term: 2015)

    assert_equal 10, summaries.fetch(land1.id).rolls
    assert_equal 10, summaries.fetch(land2.id).rolls
    assert_equal :within_10, summaries.fetch(land1.id).status
  end

  test "複数日にまたがる圃場は10a換算値を加算する" do
    land = create_land(place: "B-1", area: 20)

    first_work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    first_work_land = WorkLand.create!(work: first_work, land: land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: first_work.whole_crop, work_land: first_work_land, rolls: 20)

    second_work = create_wcs_work(worked_at: Date.new(2015, 7, 1))
    second_work_land = WorkLand.create!(work: second_work, land: land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: second_work.whole_crop, work_land: second_work_land, rolls: 10)

    summaries = HarvestWholeCrops::MapService.call(organization: organizations(:org), term: 2015)

    assert_equal 15, summaries.fetch(land.id).rolls
    assert_equal :over_50, summaries.fetch(land.id).status
  end

  test "収穫実績(whole_crop_lands)のない圃場は集計に含めない" do
    work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    land = create_land(place: "C-1", area: 10)
    WorkLand.create!(work: work, land: land, work_type_id: 15)

    summaries = HarvestWholeCrops::MapService.call(organization: organizations(:org), term: 2015)

    assert_not summaries.key?(land.id)
  end

  test "他組織の作業を集計しない" do
    other_land = lands(:land_other_org)
    other_work = works(:work_other_org)
    other_whole_crop = WorkWholeCrop.create!(work: other_work)
    other_work_land = WorkLand.create!(work: other_work, land: other_land, work_type_id: 11)
    WholeCropLand.create!(work_whole_crop: other_whole_crop, work_land: other_work_land, rolls: 10)

    summaries = HarvestWholeCrops::MapService.call(organization: organizations(:org), term: 2015)

    assert_not summaries.key?(other_land.id)
  end

  test "10a換算値を四捨五入して7段階の色に分類する" do
    service = HarvestWholeCrops::MapService.new(organization: organizations(:org), term: 2015)

    assert_equal :under_50, service.send(:status_for, 7)
    assert_equal :under_50, service.send(:status_for, 0)
    assert_equal :under_25, service.send(:status_for, 8)
    assert_equal :under_10, service.send(:status_for, 9)
    assert_equal :within_10, service.send(:status_for, 10)
    assert_equal :over_10, service.send(:status_for, 11)
    assert_equal :over_25, service.send(:status_for, 12)
    assert_equal :over_50, service.send(:status_for, 13)

    assert_equal "#ff4d4f", HarvestWholeCrops::MapService::COLORS.fetch(:over_50)
    assert_equal "#ff9500", HarvestWholeCrops::MapService::COLORS.fetch(:over_25)
    assert_equal "#ffd60a", HarvestWholeCrops::MapService::COLORS.fetch(:over_10)
    assert_equal "#34c759", HarvestWholeCrops::MapService::COLORS.fetch(:within_10)
    assert_equal "#64d2ff", HarvestWholeCrops::MapService::COLORS.fetch(:under_10)
    assert_equal "#0a84ff", HarvestWholeCrops::MapService::COLORS.fetch(:under_25)
    assert_equal "#003a8c", HarvestWholeCrops::MapService::COLORS.fetch(:under_50)
  end

  test "小数点以下を四捨五入してから段階を判定する" do
    land = create_land(place: "D-1", area: 20)
    work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    work_land = WorkLand.create!(work: work, land: land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: work.whole_crop, work_land: work_land, rolls: 19)

    summaries = HarvestWholeCrops::MapService.call(organization: organizations(:org), term: 2015)

    assert_equal 10, summaries.fetch(land.id).rolls
    assert_equal :within_10, summaries.fetch(land.id).status
  end

  private

  def create_wcs_work(worked_at:)
    work = Work.create!(
      term: 2015,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type_id: 15,
      work_kind_id: works(:work_wcs2).work_kind_id,
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkWholeCrop.create!(work: work)
    work
  end

  def create_land(place:, area:)
    Land.create!(
      place: place,
      area: area,
      target_flag: true,
      owner_id: homes(:home1).id,
      manager_id: homes(:home1).id,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
  end
end
