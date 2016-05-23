class CreateMachinePriceValues < ActiveRecord::Migration
  def change
    create_table :machine_price_values do |t|
      t.integer :machine_price_group_id, {null: false}
      t.integer :work_kind_id, {null: false}
      t.integer :lease_id, {null: false}

      t.integer :adjust_id
      t.decimal :price, {scale: 0, precision: 5, null: false, default: 0}

      t.timestamps null: false
    end
    add_index :machine_price_values, [:machine_price_group_id, :work_kind_id, :lease_id], {unique: true, name: :machine_price_values_2nd_key}
  end
end
