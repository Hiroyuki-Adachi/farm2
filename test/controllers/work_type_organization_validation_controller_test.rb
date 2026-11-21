require "test_helper"

# #1305 画面から他組織の作業分類IDを直接指定しても保存できない。
class WorkTypeOrganizationValidationControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @other_work_type = work_types(:work_type_org2)
  end

  test "保有米単価に他組織の作業分類を登録できない" do
    assert_no_difference("OwnedRicePrice.count") do
      post owned_rice_prices_path, params: {
        owned_rice_price: {
          term: 2015, work_type_id: @other_work_type.id, display_order: 99,
          name: "他組織米", short_name: "他米", owned_price: 6500
        }
      }
    end
    assert_response :unprocessable_content

    price = owned_rice_prices(:owned_rice_price1)
    before = price.work_type_id
    patch owned_rice_price_path(price), params: { owned_rice_price: { work_type_id: @other_work_type.id } }
    assert_response :unprocessable_content
    assert_equal before, price.reload.work_type_id
  end

  test "土地原価に他組織の作業分類を登録できない" do
    land = lands(:lands0)
    travel_to(Date.new(2015, 1, 1)) do
      assert_no_difference("LandCost.count") do
        post land_costs_path, params: {
          land_costs: { 0 => { work_type_id: @other_work_type.id, land_id: land.id, activated_on: "2015-06-01" } }
        }
      end
      assert_redirected_to land_costs_path
    end
  end

  test "ソリマチの配賦に他組織の作業分類を登録できない" do
    journal = sorimachi_journals(:journal2)

    patch sorimachi_work_type_path(sorimachi_journal_id: journal.id), params: {
      sorimachi: { amounts: { @other_work_type.id => 100 } }
    }
    assert_response :success
    assert_not journal.sorimachi_work_types.exists?(work_type_id: @other_work_type.id)
  end

  test "日報の選択肢に他組織の作業分類を出さず直接指定しても登録できない" do
    travel_to(Date.new(2015, 5, 1)) do
      get new_work_path
      assert_response :success
      assert_select "input#work_type_#{@other_work_type.id}", count: 0

      assert_no_difference("Work.count") do
        post works_path, params: {
          work: {
            worked_at: "2015-05-05", weather_id: :sunny, start_at: "08:00:00", end_at: "17:00:00",
            work_type_id: @other_work_type.id, work_kind_id: work_kinds(:work_kind_taue).id, name: "混入"
          },
          regist: true
        }
      end
    end
  end
end
