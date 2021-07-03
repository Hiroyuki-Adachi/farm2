class AddMachineIdToTotalCost < ActiveRecord::Migration[6.1]
  def change
    add_column :total_costs, :machine_id, :integer,  {null: true, comment: "機械"}
  end
end
