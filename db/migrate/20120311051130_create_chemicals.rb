class CreateChemicals < ActiveRecord::Migration
  def change
    create_table :chemicals, {comment: "薬剤マスタ"} do |t|
      t.string  :name,              {null: false, limit: 20, comment: "薬剤名称"}
      t.integer :display_order,     {null: false, default: 0, comment: "表示順"}
      t.integer :chemical_type_id,  {null: false, comment: "薬剤種別"}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :chemicals, :deleted_at
  end
end
