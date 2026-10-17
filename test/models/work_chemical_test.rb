require 'test_helper'

# == Schema Information
#
# Table name: work_chemicals(薬剤使用データ)
#
#  id(薬剤使用データ)                  :integer          not null, primary key
#  area_flag(10a当たり入力)            :boolean          default(FALSE), not null
#  chemical_group_no(薬剤グループ番号) :integer          default(1), not null
#  magnification(水溶液(リットル))     :decimal(6, 1)
#  quantity(使用量)                    :decimal(5, 1)    default(0.0), not null
#  remarks(備考)                       :text             default(""), not null
#  created_at                          :datetime
#  updated_at                          :datetime
#  chemical_id(薬剤)                   :integer          not null
#  dilution_id(希釈)                   :integer          default(0), not null
#  work_id(作業)                       :integer          not null
#
# Indexes
#
#  work_chemicals_2nd_key  (work_id,chemical_id,chemical_group_no) UNIQUE
#
class WorkChemicalTest < ActiveSupport::TestCase
  test "希釈水量(使用量単位がcc/gの場合)" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 100, magnification: 200
    )

    assert_equal 20, work_chemical.dilution_amount
  end

  test "希釈水量(使用量単位が本など個数単位の場合はbase_quantityで実量換算してから計算)" do
    chemical = Chemical.new(unit: "本", base_quantity: 500)
    work_chemical = WorkChemical.new(chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 2, magnification: 200)

    assert_equal 200, work_chemical.dilution_amount
  end

  test "希釈無のときはnil" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(chemical: chemical, dilution_id: Dilution::NONE.id, quantity: 100)

    assert_nil work_chemical.dilution_amount
  end

  test "希釈選択済でもmagnification未入力のときは例外にならずnil" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 100, magnification: nil
    )

    assert_nil work_chemical.dilution_amount
  end

  test "個数単位でbase_quantityが未設定/0のときは実量換算できないためnil" do
    chemical = Chemical.new(unit: "本", base_quantity: 0)
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 2, magnification: 200
    )

    assert_nil work_chemical.dilution_amount
  end
  test "希釈倍率の上限と数値を検証する" do
    record = WorkChemical.new(work: works(:work_not_fixed), chemical: chemicals(:chemicals3), quantity: 30)
    [20_000, 99_999.9, 3.3333, nil].each do |value|
      record.magnification = value
      assert record.valid?, record.errors.full_messages.join(', ')
    end
    [100_000, 99_999.96, -1, 'abc'].each do |value|
      record.magnification = value
      assert_not record.valid?
      assert record.errors[:magnification].any?
    end
  end

  test "使用量のDB上限を検証する" do
    record = WorkChemical.new(work: works(:work_not_fixed), chemical: chemicals(:chemicals3), quantity: 9999.9)
    assert record.valid?
    [10_000, 9999.96, -1, 'abc'].each do |value|
      record.quantity = value
      assert_not record.valid?
      assert record.errors[:quantity].any?
    end
  end
  test "未入力の使用量では表示用の計算を行わない" do
    record = WorkChemical.new(work: works(:works1), chemical: chemicals(:chemicals2),
                              quantity: '', dilution_id: Dilution::L.id, magnification: 20_000)
    assert_nil record.quantity10
    assert_nil record.dilution_amount
  end
end
