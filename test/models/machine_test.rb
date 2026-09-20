# == Schema Information
#
# Table name: machines(機械マスタ)
#
#  id(機械マスタ)                    :integer          not null, primary key
#  deleted_at                        :datetime
#  diesel_flag(ディーゼル)           :boolean          default(FALSE), not null
#  display_order(表示順)             :integer          not null
#  name(機械名称)                    :string(40)       not null
#  number(番号)                      :integer
#  validity_end_at(稼動終了(予定)日) :date
#  validity_start_at(稼動開始日)     :date
#  created_at                        :datetime
#  updated_at                        :datetime
#  home_id(所有者)                   :integer          default(0), not null
#  machine_type_id(機械種別)         :integer          default(0), not null
#
require "test_helper"

class MachineTest < ActiveSupport::TestCase
  test "ordered_for_display orders machines deterministically" do
    owner = homes(:home1)
    later_type = FactoryBot.create(:machine_type, name: "後の機種", display_order: 2)
    earlier_type = FactoryBot.create(:machine_type, name: "先の機種", display_order: 1)
    same_order_type = FactoryBot.create(:machine_type, name: "同順位の機種", display_order: 1)

    later_machine = FactoryBot.create(:machine, machine_type: later_type, owner: owner, display_order: 1)
    same_type_later_machine = FactoryBot.create(:machine, machine_type: earlier_type, owner: owner, display_order: 2)
    same_type_earlier_machine = FactoryBot.create(:machine, machine_type: earlier_type, owner: owner, display_order: 1)
    same_type_same_order_machine = FactoryBot.create(
      :machine, machine_type: earlier_type, owner: owner, display_order: 1
    )
    same_order_type_machine = FactoryBot.create(:machine, machine_type: same_order_type, owner: owner, display_order: 1)

    machines = [
      later_machine, same_type_later_machine, same_type_earlier_machine,
      same_type_same_order_machine, same_order_type_machine
    ]
    expected = [
      same_type_earlier_machine, same_type_same_order_machine, same_type_later_machine,
      same_order_type_machine, later_machine
    ]

    assert_equal expected, Machine.where(id: machines).ordered_for_display
  end

  test "trucks preloads owners" do
    organization = organizations(:org)
    truck = FactoryBot.create(:machine, owner: homes(:home1))
    organization.update!(truck_id: truck.machine_type_id)

    trucks = Machine.trucks(organization).to_a

    assert_includes trucks, truck
    assert_predicate trucks.find { |current_truck| current_truck.id == truck.id }.association(:owner), :loaded?
  end
end
