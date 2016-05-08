class CreateMachineResults < ActiveRecord::Migration
  def change
    create_table :machine_results do |t|
      t.integer :machine_id
      t.integer :work_result_id
      t.integer :display_order, {null: false, default: 1}
      t.decimal :hours,         {null: false, default: 0, precision: 3, scale: 1}
      t.decimal :areas,         {null: false, default: 0, precision: 6, scale: 2}

      t.timestamps
    end
    add_index :machine_results, [:machine_id, :work_result_id], {unique: true}
  end
end
