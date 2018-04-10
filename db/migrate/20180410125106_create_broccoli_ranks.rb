class CreateBroccoliRanks < ActiveRecord::Migration
  def change
    create_table :broccoli_ranks, comment: "ブロッコリ等級マスタ" do |t|
      t.string  :display_name,  {limit: 10, null: false, default: "", comment: "表示名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end
  end
end
