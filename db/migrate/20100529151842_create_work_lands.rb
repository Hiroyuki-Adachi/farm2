class CreateWorkLands < ActiveRecord::Migration
  def change
    create_table :work_lands do |t|
      t.integer :work_id
      t.integer :land_id
      t.integer :display_order, {null: false, default: 0}

      t.timestamps
    end
    add_index :work_lands, [:work_id, :land_id], {unique: true}
  end
end
