class CreateChemicalTypes < ActiveRecord::Migration
  def change
    create_table :chemical_types, {comment: "薬剤種別マスタ"} do |t|
      t.string  :name,          {null: false, limit: 20, comment: "薬剤種別名称"}
      t.integer :display_order, {null: false, default: 1, comment: "表示順"}

      t.timestamps
    end
  end
end
