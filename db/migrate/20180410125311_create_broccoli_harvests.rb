class CreateBroccoliHarvests < ActiveRecord::Migration
  def up
    create_table :broccoli_harvests, {comment: "ブロッコリー収穫"} do |t|
      t.integer :work_broccoli_id, {null: false, comment: "ブロッコリー作業"}
      t.integer :broccoli_rank_id, {null: false, comment: "ブロッコリー等級"}
      t.integer :broccoli_size_id, {null: false, comment: "ブロッコリー階級"}
      t.decimal :inspection, {scale: 0, precision: 3, null: false, default: 0, comment: "検査後数量"}

      t.timestamps null: false
    end
    add_index :broccoli_harvests, [:work_broccoli_id, :broccoli_rank_id, :broccoli_size_id], {unique: true, name: "broccoli_harvest_sheet"}
  end

  def down
    drop_table :broccoli_harvests
  end
end
