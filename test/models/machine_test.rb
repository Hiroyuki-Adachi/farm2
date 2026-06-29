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
    later_type = MachineType.create!(name: "後の機種", display_order: 2)
    earlier_type = MachineType.create!(name: "先の機種", display_order: 1)
    same_order_type = MachineType.create!(name: "同順位の機種", display_order: 1)

    later_machine = create_machine(later_type, owner, display_order: 1)
    same_type_later_machine = create_machine(earlier_type, owner, display_order: 2)
    same_type_earlier_machine = create_machine(earlier_type, owner, display_order: 1)
    same_type_same_order_machine = create_machine(earlier_type, owner, display_order: 1)
    same_order_type_machine = create_machine(same_order_type, owner, display_order: 1)

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
    truck_type = machine_types(:machine_types_removable)
    organization = organizations(:org)
    organization.update!(truck_id: truck_type.id)
    truck = Machine.create!(
      name: "",
      display_order: 1,
      validity_start_at: Date.new(2015, 1, 1),
      validity_end_at: Date.new(2099, 12, 31),
      machine_type: truck_type,
      owner: homes(:home1),
      diesel_flag: false
    )

    trucks = Machine.trucks(organization).to_a

    assert_includes trucks, truck
    assert_predicate trucks.find { |current_truck| current_truck.id == truck.id }.association(:owner), :loaded?
  end

  private

  def create_machine(machine_type, owner, display_order:)
    Machine.create!(
      name: "",
      display_order: display_order,
      validity_start_at: Date.new(2015, 1, 1),
      validity_end_at: Date.new(2099, 12, 31),
      machine_type: machine_type,
      owner: owner,
      diesel_flag: false
    )
  end
end
