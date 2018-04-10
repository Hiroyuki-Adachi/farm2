class CreateWorkBroccolis < ActiveRecord::Migration
  def change
    create_table :work_broccolis, {comment: "ブロッコリー作業"} do |t|
      t.integer :work_id, {null: false, comment: "作業"}
      t.integer :broccoli_box_id, {null: false, comment: "箱"}
      t.date :shipped_on, {null: false, comment: "出荷日"}
      t.decimal :rest, {scale: 0, precision: 3, null: false, default: 0, comment: "残数"}
      t.timestamps null: false
    end
  end
end
