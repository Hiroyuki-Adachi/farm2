require "test_helper"

class MachineTest < ActiveSupport::TestCase
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
end
