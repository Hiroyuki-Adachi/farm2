class CreateWorkLands < ActiveRecord::Migration
  def change
    create_table :work_lands, {comment: "作業地データ"} do |t|
      t.integer :work_id, {comment: "作業"}
      t.integer :land_id, {comment: "土地"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps
    end
    add_index :work_lands, [:work_id, :land_id], {unique: true}
  end
end
