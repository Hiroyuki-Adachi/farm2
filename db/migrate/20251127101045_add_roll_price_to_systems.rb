class AddRollPriceToSystems < ActiveRecord::Migration[8.1]
  def change
    add_column :systems, :roll_price, :decimal, precision: 4, scale: 1, default: 0.0, null: false
  end
end
