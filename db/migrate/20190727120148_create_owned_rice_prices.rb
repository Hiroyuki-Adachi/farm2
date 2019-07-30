class CreateOwnedRicePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :owned_rice_prices, comment: "保有米単価" do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :work_type_id, {null: false, default: 0, comment: "品種"}
      t.string  :name, {null: false, limit: 10, default: "", comment: "品種名"}
      t.decimal :owned_price, {null: false, scale: 0, precision: 5, default: 0, comment: "保有米価格"}
      t.decimal :relative_price, {null: false, scale: 0, precision: 5, default: 0, comment: "縁故米価格"}

      t.timestamps
    end
    add_index :owned_rice_prices, [:term, :work_type_id], {unique: true, name: "owned_rice_prices_2nd"}
  end
end
