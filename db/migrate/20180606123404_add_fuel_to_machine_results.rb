class AddFuelToMachineResults < ActiveRecord::Migration[4.2]
  def change
    add_column :machine_results, :fuel_usage, :decimal, {scale: 2, precision: 5, null: false, default: 0, comment: "燃料使用量"}
    add_column :systems, :light_oil_price, :decimal, {scale: 0, precision: 4, null: false, default: 0, comment: "軽油価格"}
  end
end
