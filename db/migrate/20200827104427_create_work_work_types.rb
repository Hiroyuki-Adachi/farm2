class CreateWorkWorkTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :work_work_types, {id: false, comment: "作業分類キャッシュ"} do |t|
      t.integer :work_id, {null: false, comment: "作業"}
      t.integer :work_type_id, {null: false, comment: "作業分類"}

      t.timestamps
    end
    add_index :work_work_types, [:work_id, :work_type_id], {unique: true, name: "work_work_types_2nd"}
  end
end
