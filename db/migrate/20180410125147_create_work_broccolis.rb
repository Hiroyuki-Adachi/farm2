class CreateWorkBroccolis < ActiveRecord::Migration[4.2]
  def up
    create_table :work_broccolis, {comment: "ブロッコリー作業"} do |t|
      t.integer :work_id, {null: false, comment: "作業"}
      t.integer :broccoli_box_id, {null: false, comment: "箱"}
      t.date :shipped_on, {null: false, comment: "出荷日"}
      t.decimal :rest, {scale: 0, precision: 3, null: false, default: 0, comment: "残数"}
      t.timestamps null: false
    end
    add_index :work_broccolis, [:work_id], {unique: true}
  end

  def down
    drop_table :work_broccolis
  end
end
