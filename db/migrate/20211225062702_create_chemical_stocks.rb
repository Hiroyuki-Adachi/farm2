class CreateChemicalStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :chemical_stocks, comment: "農薬在庫" do |t|
      t.date      :stock_on,              null: false, comment: "在庫日"
      t.integer   :chemical_id,           null: false, comment: "薬剤"
      t.integer   :work_chemical_id,      null: true, comment: "薬剤使用"
      t.integer   :chemical_inventory_id, null: true, comment: "薬剤棚卸"
      t.string    :name,      limit: 40, null: false, default: "", comment: "在庫名称"
      t.decimal   :stored,    null: true,  precision: 5, scale: 1, comment: "入庫量"
      t.decimal   :shipping,  null: true,  precision: 5, scale: 1, comment: "出庫量"
      t.decimal   :using,     null: true,  precision: 5, scale: 1, comment: "使用量"
      t.decimal   :inventory, null: true,  precision: 7, scale: 1, comment: "棚卸量"
      t.decimal   :stock,     null: false, precision: 7, scale: 1, default: 0, comment: "在庫量"
      t.decimal   :adjust,    null: false, precision: 5, scale: 1, default: 0, comment: "調整量"
      t.timestamps
    end

    add_column :chemicals, :stock_unit, :string, limit: 2, null: false, default: "", comment: "在庫単位"
    add_column :chemicals, :stock_quantity, :decimal, scale: 0, precision: 6, null: false, default: 0, comment: "在庫数"
  end
end
