class CreateBroccoliSizes < ActiveRecord::Migration[4.2]
  def up
    create_table :broccoli_sizes, comment: "ブロッコリ階級マスタ"  do |t|
      t.string  :display_name,  {limit: 10, null: false, default: "", comment: "表示名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end
    BroccoliSize.create(display_name: "5L", display_order: 10)
    BroccoliSize.create(display_name: "4L", display_order: 20)
    BroccoliSize.create(display_name: "3L", display_order: 30)
    BroccoliSize.create(display_name: "2L", display_order: 40)
    BroccoliSize.create(display_name: "L", display_order: 50)
    BroccoliSize.create(display_name: "M", display_order: 60)
    BroccoliSize.create(display_name: "S", display_order: 70)
    BroccoliSize.create(display_name: "2S", display_order: 80)
  end

  def down
    drop_table :broccoli_sizes
  end
end
