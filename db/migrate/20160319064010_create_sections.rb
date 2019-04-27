class CreateSections < ActiveRecord::Migration[4.2]
  def change
    create_table :sections, {comment: "班／町内マスタ"} do |t|
      t.string  :name,          {null: false, limit: 40, comment: "班名称"}
      t.integer :display_order, {null: false, limit: 4, default: 1, comment: "表示順"}
      t.boolean :work_flag,     {null: false, default: true, comment: "作業班フラグ"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :sections, :deleted_at
  end
end
