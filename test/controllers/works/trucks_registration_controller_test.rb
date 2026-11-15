require "test_helper"

class Works::TrucksRegistrationControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    @home1_truck = create_truck(homes(:home1))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_shirokaki))
    @health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
  end

  test "0以外の入力で machine_result を追加する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))

    assert_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "2.5" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal "登録しました。", flash[:notice]
    machine_result = MachineResult.find_by!(machine: @home1_truck, work_result: work_result)
    assert_equal 2.5, machine_result.hours
  end

  test "0以外の入力で既存 machine_result を更新する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "3.0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 3.0, machine_result.reload.hours
  end

  test "0の入力で既存 machine_result を削除する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_difference("MachineResult.count", -1) do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_nil MachineResult.find_by(id: machine_result.id)
  end

  test "自家用車所有者と作業者世帯が一致しない machine_result 登録は無視する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    other_home_work_result = create_work_result(work, workers(:worker6))

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { other_home_work_result.id => "2.5" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_nil MachineResult.find_by(machine: @home1_truck, work_result: other_home_work_result)
  end

  test "範囲外または 0.5 刻みではない賃借量は無視する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    existing_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)
    invalid_work = create_work(Date.new(2015, 2, 6), work_kinds(:work_kind_shirokaki))
    invalid_work_result = create_work_result(invalid_work, workers(:worker1))

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: {
          @home1_truck.id => {
            work_result.id => "10.0",
            invalid_work_result.id => "1.25"
          }
        }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 1.5, existing_result.reload.hours
    assert_nil MachineResult.find_by(machine: @home1_truck, work_result: invalid_work_result)
  end

  test "締め済み work の machine_result 更新は無視する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki), fixed_at: Date.new(2015, 2, 28))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 1.5, machine_result.reload.hours
  end

  test "稼働期間外の作業日への machine_result 追加は無視する" do
    out_of_period_truck = create_truck(
      homes(:home1),
      validity_start_at: Date.new(2015, 3, 1),
      validity_end_at: Date.new(2015, 3, 31)
    )
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { out_of_period_truck.id => { work_result.id => "2.5" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_nil MachineResult.find_by(machine: out_of_period_truck, work_result: work_result)
  end

  test "稼働期間外でも既存 machine_result は更新・削除できる" do
    out_of_period_truck = create_truck(
      homes(:home1),
      validity_start_at: Date.new(2015, 3, 1),
      validity_end_at: Date.new(2015, 3, 31)
    )
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: out_of_period_truck, work_result: work_result, hours: 1.5)

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { out_of_period_truck.id => { work_result.id => "3.0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 3.0, machine_result.reload.hours

    assert_difference("MachineResult.count", -1) do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { out_of_period_truck.id => { work_result.id => "0" } }
      )
    end

    assert_nil MachineResult.find_by(id: machine_result.id)
  end

  test "全ての条件で異なる月と班の利用実績を登録して選択を維持する" do
    other_truck = create_truck(homes(:home6))
    first_work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    other_work = create_work(Date.new(2015, 3, 5), work_kinds(:work_kind_shirokaki))
    first_result = create_work_result(first_work, workers(:worker1))
    other_result = create_work_result(other_work, workers(:worker6))

    assert_difference("MachineResult.count", 2) do
      post works_trucks_path, params: {
        work_kind_id: "", month: "all", section_id: "",
        machine_hours: {
          @home1_truck.id => { first_result.id => "2.5" },
          other_truck.id => { other_result.id => "3.0" }
        }
      }
    end

    assert_redirected_to works_trucks_path(month: "all")
    follow_redirect!
    %w[work-kind month section].each do |tab|
      assert_select "#truck-#{tab}-tabs a:first-child.btn-primary", "全て"
    end
    assert_select "input[name='machine_hours[#{@home1_truck.id}][#{first_result.id}]'][value='2.5']", 1
    assert_select "input[name='machine_hours[#{other_truck.id}][#{other_result.id}]'][value='3.0']", 1
  end

  test "個別条件と全てを組み合わせても登録後に選択を維持する" do
    filters = filter_params.merge(month: "all")

    post works_trucks_path, params: filters

    assert_redirected_to works_trucks_path(filters)
    follow_redirect!
    assert_select "#truck-work-kind-tabs a.btn-primary", work_kinds(:work_kind_shirokaki).name
    assert_select "#truck-month-tabs a:first-child.btn-primary", "全て"
    assert_select "#truck-section-tabs a.btn-primary", sections(:sections0).name
  end

  test "直接金額は7桁まで保存して再表示し使用料に反映する" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    result = create_work_result(work, workers(:worker1))
    post works_trucks_path, params: filter_params.merge(
      machine_amounts: { @home1_truck.id => { result.id => "9999999" } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    entry = MachineResult.find_by!(machine: @home1_truck, work_result: result)
    assert_equal 9_999_999, entry.input_amount
    assert_equal 0, entry.hours
    assert_equal 9_999_999, work.sum_machines_amount
    follow_redirect!
    assert_select "input[name=?][value=?]", "machine_amounts[#{@home1_truck.id}][#{result.id}]", "9999999"

    displayed_amount = css_select("input[name='machine_amounts[#{@home1_truck.id}][#{result.id}]']").first["value"]
    post works_trucks_path, params: filter_params.merge(
      machine_amounts: { @home1_truck.id => { result.id => displayed_amount } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 9_999_999, entry.reload.input_amount
  end

  test "直接金額の0円を保持し空欄で利用を削除する" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    result = create_work_result(work, workers(:worker1))
    entry = MachineResult.create!(machine: @home1_truck, work_result: result, input_amount: 1000)
    post works_trucks_path, params: filter_params.merge(
      machine_amounts: { @home1_truck.id => { result.id => "0" } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 0, entry.reload.input_amount
    post works_trucks_path, params: filter_params.merge(
      machine_amounts: { @home1_truck.id => { result.id => "" } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    assert_not MachineResult.exists?(entry.id)
  end

  test "不正な直接金額は全体を保存せず入力値とエラーを再表示する" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    result = create_work_result(work, workers(:worker1))
    entry = MachineResult.create!(machine: @home1_truck, work_result: result, input_amount: 1000)
    other_truck = create_truck(homes(:home1))
    header = FactoryBot.create(:machine_price_header, machine: other_truck, validated_at: Date.new(2000, 1, 1))
    FactoryBot.create(:machine_price_detail, header: header, lease_id: :normal, adjust_id: Adjust::HOUR.id, price: 500)
    other = MachineResult.create!(machine: other_truck, work_result: result, hours: 1)
    ["10000000", "-1", "1.5", "abc"].each do |value|
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { other_truck.id => { result.id => "2.5" } },
        machine_amounts: { @home1_truck.id => { result.id => value } }
      )
      assert_response :unprocessable_entity
      assert_select ".alert-danger", text: /使用料/
      assert_select "input[name=?][value=?]", "machine_amounts[#{@home1_truck.id}][#{result.id}]", value
      assert_equal 1000, entry.reload.input_amount
      assert_equal 1, other.reload.hours
    end
  end

  test "確定済み作業への直接金額変更は無視する" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki), fixed_at: Date.new(2015, 2, 28))
    result = create_work_result(work, workers(:worker1))
    entry = MachineResult.create!(machine: @home1_truck, work_result: result, input_amount: 1000)
    post works_trucks_path, params: filter_params.merge(
      machine_amounts: { @home1_truck.id => { result.id => "5000" } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 1000, entry.reload.input_amount
  end

  test "対象外の世帯と月への直接金額登録は無視する" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    other_home = create_work_result(work, workers(:worker6))
    other_month = create_work_result(create_work(Date.new(2015, 3, 5), work_kinds(:work_kind_shirokaki)), workers(:worker1))
    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_amounts: { @home1_truck.id => { other_home.id => "5000", other_month.id => "5000" } }
      )
    end
    assert_redirected_to works_trucks_path(filter_params)
  end

  test "直接金額区分へ時間を送信しても金額を上書きしない" do
    set_amount_price
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    result = create_work_result(work, workers(:worker1))
    entry = MachineResult.create!(machine: @home1_truck, work_result: result, input_amount: 5000)
    post works_trucks_path, params: filter_params.merge(
      machine_hours: { @home1_truck.id => { result.id => "0" } }
    )
    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 5000, entry.reload.input_amount
  end

  private

  def set_amount_price
    header = FactoryBot.create(:machine_price_header, machine_type: @truck_type,
                                                      validated_at: Date.new(2000, 1, 1))
    FactoryBot.create(:machine_price_detail, header: header, lease_id: :normal,
                                            adjust_id: Adjust::AMOUNT.id, price: 0)
  end


  def filter_params
    {
      work_kind_id: work_kinds(:work_kind_shirokaki).id,
      month: Date.new(2015, 2, 1),
      section_id: sections(:sections0).id
    }
  end

  def create_work_result(work, worker)
    WorkResult.create!(work: work, worker: worker, health: @health, hours: 1.0, display_order: 1)
  end

  def create_work(worked_at, work_kind, fixed_at: nil)
    Work.create!(
      term: 2015,
      worked_at: worked_at,
      fixed_at: fixed_at,
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: Time.zone.local(2015, 2, 1, 8, 0, 0),
      end_at: Time.zone.local(2015, 2, 1, 17, 0, 0),
      organization: organizations(:org)
    )
  end

  def create_truck(home, validity_start_at: Date.new(2015, 1, 1), validity_end_at: Date.new(2099, 12, 31))
    Machine.create!(
      name: "",
      display_order: 1,
      validity_start_at: validity_start_at,
      validity_end_at: validity_end_at,
      machine_type_id: @truck_type.id,
      home_id: home.id,
      diesel_flag: false
    )
  end
end
