class CreateBroccoliRanks < ActiveRecord::Migration[4.2]
  def up
    create_table :broccoli_ranks, comment: "ブロッコリ等級マスタ" do |t|
      t.string  :display_name,  {limit: 10, null: false, default: "", comment: "表示名"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end
    BroccoliRank.create(display_name: "秀(赤)", display_order: 10)
    BroccoliRank.create(display_name: "秀(青)", display_order: 20)
    BroccoliRank.create(display_name: "優", display_order: 30)
    BroccoliRank.create(display_name: "良", display_order: 40)
  end

  def down
    drop_table :broccoli_ranks
  end
end
