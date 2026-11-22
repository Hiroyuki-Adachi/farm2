require "test_helper"

class Works::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @work = works(:work_not_fixed)
  end

  test "作業変更(薬品)(表示)" do
    get new_work_use_chemical_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(薬品)(表示)(作付明細なしの農地は除外)" do
    land_without_cost = lands(:land_land_cost2)
    work_land = @work.work_lands.create!(
      land: land_without_cost,
      work_type: work_types(:work_type_koshi),
      display_order: 99
    )

    get new_work_use_chemical_path(work_id: @work)

    assert_response :success
    assert_select "#work_land_#{work_land.id}", false
    assert_no_match land_without_cost.place, response.body
  end

  test "作業変更(薬品)(表示)(確定済)" do
    get new_work_use_chemical_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(表示)(希釈無のとき希釈情報は無選択かつdisabled)" do
    work = works(:works1)
    chemical = chemicals(:chemicals2)
    work_chemical = work.work_chemicals.find_by(chemical_id: chemical.id, chemical_group_no: 1)
    assert_not chemical.aqueous_flag
    assert_equal Dilution::NONE.id, work_chemical.dilution_id

    get new_work_use_chemical_path(work_id: work)

    assert_response :success
    assert_select "#chemicals_#{chemical.id}_1_#{Dilution::NONE.id}[checked]"
    assert_select "input[name='chemicals[#{chemical.id}][1][magnification]'][disabled]"
    assert_select "input[name='chemicals[#{chemical.id}][1][dilution_amount]'][disabled]"
  end

  test "作業変更(薬品)(変更)" do
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    } } }
    assert_difference('WorkChemical.count') do
      post work_use_chemicals_path(work_id: @work), params: {
        chemicals: chemicals,
        work: { chemical_group_flag: false }
      }
    end
    assert_redirected_to work_path(id: @work)

    created_work_chemical = WorkChemical.last
    assert_equal @work.id, created_work_chemical.work_id
    assert_equal chemical.id, created_work_chemical.chemical_id
    assert_equal chemicals[4][1][:dilution_id], created_work_chemical.dilution_id
    assert_equal chemicals[4][1][:magnification], created_work_chemical.magnification
  end

  test "作業変更(薬品)(変更)(希釈なしに変更すると希釈倍率がクリアされる)" do
    chemical = chemicals(:chemicals3)

    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemical.id => { 1 => {
        dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
      } } },
      work: { chemical_group_flag: false }
    }
    work_chemical = WorkChemical.find_by(work_id: @work.id, chemical_id: chemical.id, chemical_group_no: 1)
    assert_equal 10, work_chemical.magnification.to_i

    # ブラウザ上は dilution_id を無に切り替えると magnification 欄が disabled になり送信されないため、
    # そのケースを再現するためにパラメータから magnification を含めない
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemical.id => { 1 => {
        dilution_id: 0, quantity: 10
      } } },
      work: { chemical_group_flag: false }
    }
    work_chemical.reload
    assert_equal 0, work_chemical.dilution_id
    assert_nil work_chemical.magnification
    assert_nil work_chemical.dilution_amount
  end

  test "作業変更(薬品)(変更)(薬剤グループ)" do
    work_lands_not_fixed1 = work_lands(:work_lands_not_fixed1)
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    } } }
    chemical_group_no = 1

    # 薬剤グループの指定で値に反映される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: { chemical_group_flag: true },
      work_lands: { work_lands_not_fixed1.id => chemical_group_no }
    }
    work_lands_not_fixed1.reload
    assert_equal chemical_group_no, work_lands_not_fixed1.chemical_group_no

    # 薬剤グループ解除でゼロが設定される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: { chemical_group_flag: false }
    }
    work_lands_not_fixed1.reload
    assert_equal 0, work_lands_not_fixed1.chemical_group_no
  end
  test "展着剤の20000倍と最大倍率を保存できる" do
    chemical = chemicals(:chemicals3)
    [20_000, 99_999.9].each do |magnification|
      post work_use_chemicals_path(work_id: @work), params: {
        chemicals: { chemical.id => { 1 => { quantity: 30, dilution_id: Dilution::L.id,
                                             magnification: magnification } } },
        work: { chemical_group_flag: false }
      }
      assert_redirected_to work_path(@work)
      record = @work.work_chemicals.find_by!(chemical_id: chemical.id, chemical_group_no: 1)
      assert_equal magnification, record.magnification
    end
  end

  test "範囲外の倍率では登録をロールバックして入力値とエラーを表示する" do
    chemical = chemicals(:chemicals3)
    chemical.update!(aqueous_flag: true, unit: "cc")
    assert_no_difference('WorkChemical.count') do
      post work_use_chemicals_path(work_id: @work), params: {
        chemicals: { chemical.id => {
          1 => { quantity: 30, dilution_id: Dilution::L.id, magnification: 20_000 },
          2 => { quantity: 30, dilution_id: Dilution::L.id, magnification: 100_000 }
        } },
        work: { chemical_group_flag: false }
      }
    end
    assert_response :unprocessable_entity
    assert_select "input[name='chemicals[#{chemical.id}][1][magnification]'][value='20000']"
    assert_select "input[name='chemicals[#{chemical.id}][2][magnification]'][value='100000']"
    assert_match '希釈倍率は99999.9以下の値にしてください', response.body
  end

  test "数値でない使用量を保存失敗として表示する" do
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemicals(:chemicals3).id => { 1 => { quantity: 'abc', dilution_id: Dilution::NONE.id } } },
      work: { chemical_group_flag: false }
    }
    assert_response :unprocessable_entity
  end
  test "上限超過と未入力の薬剤が混在してもエラー画面を表示できる" do
    work = works(:works1)
    chemical = chemicals(:chemicals2)
    chemical.update!(aqueous_flag: true, unit: 'cc')
    assert work.sum_areas.positive?
    assert_no_difference('WorkChemical.count') do
      post work_use_chemicals_path(work_id: work), params: {
        chemicals: {
          chemical.id => {
            1 => { quantity: 30, dilution_id: Dilution::L.id, magnification: 200_000, dilution_amount: 6000 },
            2 => { quantity: '', dilution_id: Dilution::NONE.id }
          },
          chemicals(:chemicals3).id => { 1 => { quantity: '', dilution_id: Dilution::NONE.id } }
        },
        work: { chemical_group_flag: false }
      }
    end
    assert_response :unprocessable_entity
    assert_select "input[name='chemicals[#{chemical.id}][1][magnification]'][value='200000']"
    assert_select "input[name='chemicals[#{chemical.id}][2][quantity]'][value='']"
    assert_match '希釈倍率は99999.9以下の値にしてください', response.body
  end

  test "薬剤の切り替えは使用行と在庫行を削除して別の使用行を作成する" do
    old_chemical = chemicals(:chemicals3)
    new_chemical = chemicals(:chemicals0)
    old_usage = @work.work_chemicals.create!(chemical: old_chemical, quantity: 10)
    ChemicalStock::Refresher.new(1, old_chemical.id).call
    old_stock = ChemicalStock.find_by!(work_chemical_id: old_usage.id)

    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: {
        old_chemical.id => { 1 => { quantity: 0, dilution_id: Dilution::NONE.id } },
        new_chemical.id => { 1 => { quantity: 20, dilution_id: Dilution::NONE.id } }
      },
      work: { chemical_group_flag: false }
    }

    assert_redirected_to work_path(@work)
    assert_not WorkChemical.exists?(old_usage.id)
    assert_not ChemicalStock.exists?(old_stock.id)
    new_usage = @work.work_chemicals.find_by!(chemical_id: new_chemical.id)
    assert_not_equal old_usage.id, new_usage.id
    ChemicalStock::Refresher.new(1, new_chemical.id).call
    assert_equal 20, ChemicalStock.find_by!(work_chemical_id: new_usage.id).using
  end

  # #1352 薬剤グループ番号はその作業の作業地だけに保存する
  test "薬剤グループ番号に他の作業の作業地を含めると404で1件も書き換えない" do
    own = work_lands(:work_lands_not_fixed1)
    other = work_lands(:work_lands2)
    other.update!(chemical_group_no: 0)

    post_chemical_group_nos(own.id => 1, other.id => 2)

    assert_response :not_found
    assert_equal 0, own.reload.chemical_group_no
    assert_equal 0, other.reload.chemical_group_no
  end

  test "薬剤グループ番号に他組織の作業の作業地を指定すると404で書き換えない" do
    other_org = works(:work_other_org).work_lands.create!(
      land: lands(:land_other_org), work_type: work_types(:work_type_org2), display_order: 1
    )

    post_chemical_group_nos(other_org.id => 1)

    assert_response :not_found
    assert_equal 0, other_org.reload.chemical_group_no
  end

  test "薬剤グループ番号が範囲外なら登録をロールバックしてエラーを表示する" do
    own = work_lands(:work_lands_not_fixed1)

    ["-1", "3", "abc", "1.5"].each do |group_no|
      assert_no_difference("WorkChemical.count") do
        post_chemical_group_nos(own.id => group_no)
      end

      assert_response :unprocessable_entity
      assert_match "#{own.land.place}の薬剤グループ番号は0から2の整数で指定してください", response.body
      assert_equal 0, own.reload.chemical_group_no
    end
  end

  test "薬剤グループ番号は組織のグループ数まで保存できる" do
    own = work_lands(:work_lands_not_fixed1)

    post_chemical_group_nos(own.id => "2")

    assert_redirected_to work_path(@work)
    assert_equal 2, own.reload.chemical_group_no
  end

  test "上限を超える番号が保存済みでも変えなければ保存でき、新たに範囲外へは変えられない" do
    own = work_lands(:work_lands_not_fixed1)
    other = work_lands(:work_lands_not_fixed2)
    # 組織の薬剤グループ数を減らした後などに残る番号
    own.update_columns(chemical_group_no: 3) # rubocop:disable Rails/SkipsModelValidations

    post_chemical_group_nos(own.id => "3")

    assert_redirected_to work_path(@work)
    assert_equal 3, own.reload.chemical_group_no

    post_chemical_group_nos(own.id => "3", other.id => "3")

    assert_response :unprocessable_entity
    assert_equal 0, other.reload.chemical_group_no
  end

  private

  def post_chemical_group_nos(group_nos)
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemicals(:chemicals3).id => { 1 => { quantity: 10, dilution_id: Dilution::NONE.id } } },
      work: { chemical_group_flag: true },
      work_lands: group_nos
    }
  end
end
