class AddRelativePriceToSystems < ActiveRecord::Migration[5.2]
  def up
    add_column :systems, :relative_price, :decimal, {null: false, scale: 0, precision: 5, default: 0, comment: "縁故米加算額"}
    remove_column :owned_rice_prices, :relative_price
    remove_column :owned_rices, :relative_count
  end

  def down
    remove_column :systems, :relative_price
    add_column :owned_rice_prices, :relative_price, :decimal, {null: false, scale: 0, precision: 5, default: 0, comment: "縁故米価格"}
    add_column :owned_rices, :relative_count, :decimal, {null: false, scale: 0, precision: 3, default: 0, comment: "縁故米数"}
  end
end
