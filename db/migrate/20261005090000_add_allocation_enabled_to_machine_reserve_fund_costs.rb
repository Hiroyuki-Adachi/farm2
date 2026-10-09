class AddAllocationEnabledToMachineReserveFundCosts < ActiveRecord::Migration[8.1]
  def change
    add_column :machine_reserve_fund_costs, :allocation_enabled, :boolean, null: false, default: true,
                                                                           comment: "面積按分対象"
  end
end
