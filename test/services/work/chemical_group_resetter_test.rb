require "test_helper"

class Work::ChemicalGroupResetterTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_not_fixed)
    @work_land = work_lands(:work_lands_not_fixed1)
    @work_land.update!(chemical_group_no: 2)
  end

  test "薬剤グループを使わない作業は作業地の薬剤グループ番号を0に戻す" do
    @work.update!(chemical_group_flag: false)

    Work::ChemicalGroupResetter.new(@work).call

    assert_equal 0, @work_land.reload.chemical_group_no
  end

  test "薬剤グループを使う作業は作業地の薬剤グループ番号を残す" do
    @work.update!(chemical_group_flag: true)

    Work::ChemicalGroupResetter.new(@work).call

    assert_equal 2, @work_land.reload.chemical_group_no
  end

  test "薬剤グループ番号が0の作業地は更新しない" do
    @work.update!(chemical_group_flag: false)
    Work::ChemicalGroupResetter.new(@work).call
    updated_at = @work_land.reload.updated_at

    travel 1.minute do
      Work::ChemicalGroupResetter.new(@work).call
    end

    assert_equal updated_at, @work_land.reload.updated_at
  end
end
