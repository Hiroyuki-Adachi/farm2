class CreateBroccoliBoxes < ActiveRecord::Migration
  def change
    create_table :broccoli_boxes, comment: "ブロッコリ箱マスタ" do |t|
      t.decimal :weight, {scale: 1, precision: 3, null: false, default: 0, comment: "重さ(kg)"}
      t.string  :display_name,  {limit: 10, null: false, default: "", comment: "表示名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end
  end
end
