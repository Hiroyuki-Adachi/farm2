class CreateWorkKinds < ActiveRecord::Migration[4.2]
  def change
    create_table :work_kinds, {comment: "作業種別マスタ"} do |t|
      t.string  :name,          {limit: 20, null: false, comment: "作業種別名称"}
      t.integer :display_order, {null: false, comment: "表示順"}
      t.boolean :other_flag,    {null: false, default: false, comment: "その他フラグ"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :work_kinds, :deleted_at
  end
end
