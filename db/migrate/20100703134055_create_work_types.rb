class CreateWorkTypes < ActiveRecord::Migration
  def change
    create_table :work_types, {comment: "作業分類マスタ"} do |t|
      t.integer   :genre,         {null: false, comment: "作業ジャンル"}
      t.string    :name,          {null: false, limit: 10, comment: "作業分類名称"}
      t.boolean   :category_flag, {default: false, comment: "カテゴリーフラグ"}
      t.integer   :display_order, {null: false, default: 0, comment: "表示順"}

      t.datetime  :deleted_at,    {null: true}
    end
    add_index :work_types, :deleted_at
  end
end
