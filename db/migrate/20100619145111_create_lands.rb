class CreateLands < ActiveRecord::Migration
  def change
    create_table :lands, {comment: "土地マスタ"} do |t|
      t.string   :place,          {limit: 15, null: false, comment: "番地"}
      t.integer  :owner_id,       {comment: "所有者"}
      t.integer  :manager_id,     {comment: "管理者"}
      t.decimal  :area,           {scale: 2, precision: 5, null: false, comment: "面積(α)"}
      t.integer  :display_order,  {comment: "表示順"}
      t.boolean  :target_flag,    {null: false, default: true, comment: "管理対象フラグ"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :lands, :deleted_at
    add_index :lands, :place
  end
end
