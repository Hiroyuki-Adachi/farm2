class CreateMachinePrices < ActiveRecord::Migration
  def change
    create_table :machine_prices do |t|
      t.date    :validity_at
      t.integer :lease_id,        {null: false, default: 1}
      t.integer :machine_id,      {null: false, default: 0}
      t.integer :machine_type_id, {null: false, default: 0}
      t.integer :work_kind_id,    {null: false, default: 0}
      t.integer :adjust_id  #精算方法
      t.decimal :price,           {scale: 0, precision: 5, null: false, default: 0}
      
      t.timestamps
    end
    add_index :machine_prices, [:validity_at], {unique: false}
    add_index :machine_prices, [:machine_type_id], {unique: false}
    add_index :machine_prices, [:machine_id],   {unique: false}
    add_index :machine_prices, [:work_kind_id], {unique: false}
    add_index :machine_prices, [:validity_at, :lease_id, :machine_id, :machine_type_id, :work_kind_id], {unique: true, name: :machine_prices_unique}
  end
end
