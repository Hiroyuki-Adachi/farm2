class CreateWorkResults < ActiveRecord::Migration
  def change
    create_table :work_results do |t|
      t.integer :work_id
      t.integer :worker_id
      t.decimal :hours,         {scale: 1, precision: 3, null: false, default: 0}
      t.integer :display_order, {null: false, default: 0}
      t.decimal :fixed_hours,   {scale: 1, precision: 3, null: true}
      t.decimal :fixed_price,   {scale: 0, precision: 4, null: true}
      t.decimal :fixed_amount,  {scale: 0, precision: 6, null: true}

      t.timestamps
    end
    add_index :work_results, [:work_id, :worker_id], {unique: true}
  end
end
