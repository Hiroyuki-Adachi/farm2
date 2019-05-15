class CreateMachines < ActiveRecord::Migration[4.2]
  def change
    create_table :machines, {comment: "機械マスタ"} do |t|
      t.string  :name,              {limit: 40, null: false, comment: "機械名称"}
      t.integer :display_order,     {null: false, comment: "表示順"}
      t.date    :validity_start_at, {comment: "稼動開始日"}
      t.date    :validity_end_at,   {comment: "稼動終了(予定)日"}
      t.integer :machine_type_id,   {null: false, default: 0, comment: "機械種別"}
      t.integer :home_id,           {null: false, default: 0, comment: "所有者"}

      t.timestamps
      t.datetime :deleted_at
    end
  end
end
