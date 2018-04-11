class CreateBroccoliBoxes < ActiveRecord::Migration
  def up
    create_table :broccoli_boxes, comment: "ブロッコリ箱マスタ" do |t|
      t.decimal :weight, {scale: 1, precision: 3, null: false, default: 0, comment: "重さ(kg)"}
      t.string  :display_name,  {limit: 10, null: false, default: "", comment: "表示名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end

    BroccoliBox.create(weight: 2, display_name: "2kg", display_order: 10)
    BroccoliBox.create(weight: 3, display_name: "3kg", display_order: 20)
    BroccoliBox.create(weight: 5, display_name: "5kg", display_order: 30)
    BroccoliBox.create(weight: 8, display_name: "8kg", display_order: 40)
    BroccoliBox.create(weight: 10, display_name: "10kg", display_order: 50)
    BroccoliBox.create(weight: 0.1, display_name: "100g", display_order: 60)
  end

  def down
    drop_table :broccoli_boxes
  end
end
