class CreateMachineTypePrices < ActiveRecord::Migration
  def change
    create_table :machine_type_prices do |t|
      t.integer :machine_type_id
      t.integer :term
      
      t.decimal :price_per_day,  {scale: 0, precision: 6, null: false, default: 0}
      t.decimal :price_per_area, {scale: 0, precision: 6, null: false, default: 0}
      t.decimal :price_per_hour, {scale: 0, precision: 6, null: false, default: 0}
    end
    add_index :machine_type_prices, [:machine_type_id, :term], {unique: true}
  end
end
