class CreateWorkResults < ActiveRecord::Migration
  def self.up
    create_table :work_results do |t|
      t.integer :work_id
      t.integer :worker_id
      t.decimal :hours,         {scale: 1, precision: 3, null: false, default: 0}
      t.integer :display_order, {null: false, default: 0}

      t.timestamps
    end
    add_index :work_results, [:work_id, :worker_id], {unique: true}
  end

  def self.down
    drop_table :work_results
  end
end
