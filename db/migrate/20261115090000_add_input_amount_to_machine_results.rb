class AddInputAmountToMachineResults < ActiveRecord::Migration[8.1]
  def change
    add_column :machine_results, :input_amount, :decimal, precision: 7, scale: 0, comment: "直接入力使用料"
  end
end
