class CreateOwnedRices < ActiveRecord::Migration[5.2]
  def change
    create_table :owned_rices, comment: "保有米" do |t|
      t.integer :home_id, {null: false, default: 0, comment: "購入世帯"}
      t.integer :owned_rice_price_id, {null: false, default: 0, comment: "保有米単価"}
      t.decimal :owned_price, {null: false, scale: 0, precision: 3, default: 0, comment: "保有米数"}
      t.decimal :relative_price, {null: false, scale: 0, precision: 3, default: 0, comment: "縁故米数"}

      t.timestamps
    end
    add_index :owned_rices, [:home_id, :owned_rice_price_id], {unique: true, name: "owned_rices_2nd"}
    add_column :homes, :owned_rice_order, :integer, {null: true, comment: "出力順(保有米)"}
  end
end
