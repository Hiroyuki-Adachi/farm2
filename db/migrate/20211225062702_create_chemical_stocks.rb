class CreateChemicalStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :chemical_stocks, {comment: "農薬在庫"} do |t|
      t.integer   :term,              {limit: 4, null: false, comment: "年度(期)"}
      t.date      :stock_on,          {null: false, comment: "在庫日"}
      t.integer   :chemical_id,       {null: false, comment: "薬剤"}
      t.integer   :work_chemical_id,  {null: true, comment: "薬剤使用"}
      t.string    :name,              {limit: 40, null: false, default: "", comment: "在庫名称"}
      t.decimal   :stored,            {null: false, precision: 5, scale: 1, default: 0, comment: "入庫量"}
      t.decimal   :shipping,          {null: false, precision: 5, scale: 1, default: 0, comment: "出庫量"}
      t.timestamps
    end
  end
end
