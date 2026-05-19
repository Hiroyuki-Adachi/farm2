require 'test_helper'

class PersonalInformations::MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(機械賃借料)" do
    machine = create_machine("公開用軽トラ", homes(:home1))
    other_home_machine = create_machine("別世帯軽トラ", homes(:home2))
    work_result = work_results(:work_results4)
    work_result.work.update!(fixed_at: Date.new(2014, 5, 31))

    MachineResult.create!(
      machine: machine,
      work_result: work_result,
      hours: 2.5,
      fixed_quantity: 2.5,
      fixed_adjust_id: Adjust::HOUR.id,
      fixed_price: 1000,
      fixed_amount: 2500
    )
    MachineResult.create!(
      machine: other_home_machine,
      work_result: work_result,
      hours: 3.0,
      fixed_quantity: 3.0,
      fixed_adjust_id: Adjust::HOUR.id,
      fixed_price: 1000,
      fixed_amount: 3000
    )

    travel_to Time.zone.local(2014, 5, 31) do
      get personal_information_machines_path(personal_information_token: @user.token)
    end

    assert_response :success
    assert_select "td div", text: "田植機"
    assert_select "td", text: /2\.5\(時間\)/
    assert_no_match "別世帯軽トラ", response.body
  end

  private

  def create_machine(name, home)
    Machine.create!(
      name: name,
      machine_type: machine_types(:machine_types1),
      owner: home,
      validity_start_at: Date.new(2014, 1, 1),
      validity_end_at: Date.new(2014, 12, 31),
      display_order: 1
    )
  end
end
