class CreateMachinePriceDetails < ActiveRecord::Migration
  def change
    create_table :machine_price_details do |t|
      t.integer :machine_price_header_id, {null: false}
      t.integer :lease_id, {null: false}
      t.integer :work_kind_id, {null: false, default: 0}
      
      t.integer :adjust_id
      t.decimal :price, {scale: 0, precision: 5, null: false, default: 0}

      t.timestamps null: false
    end
    add_index :machine_price_details, [:machine_price_header_id, :lease_id, :work_kind_id], {unique: true, name: :machine_price_details_2nd_key}
  end
end
