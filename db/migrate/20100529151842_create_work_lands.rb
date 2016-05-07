class CreateWorkLands < ActiveRecord::Migration
  def self.up
    create_table :work_lands do |t|
      t.integer :work_id
      t.integer :land_id
      t.integer :display_order, {null: false, default: 0}

      t.timestamps
    end
    add_index :work_lands, [:work_id, :land_id], {unique: true}
  end

  def self.down
    drop_table :work_lands
  end
end
