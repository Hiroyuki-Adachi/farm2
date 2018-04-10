class CreateBroccoliHarvests < ActiveRecord::Migration
  def change
    create_table :broccoli_harvests, {comment: "ブロッコリー収穫"} do |t|
      t.integer :work_broccoli_id, {null: false, comment: "ブロッコリー作業"}
      t.integer :broccoli_rank_id, {null: false, comment: "ブロッコリー等級"}
      t.integer :broccoli_size_id, {null: false, comment: "ブロッコリー階級"}
      t.decimal :inspection, {scale: 0, precision: 3, null: false, default: 0, comment: "検査後数量"}

      t.timestamps null: false
    end
  end
end
