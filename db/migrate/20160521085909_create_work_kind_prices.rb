class CreateWorkKindPrices < ActiveRecord::Migration
  def change
    create_table :work_kind_prices, {comment: "作業単価マスタ"} do |t|
      t.integer   :term, {null: false, comment: "年度(期)"}
      t.integer   :work_kind_id, {null: false, comment: "作業種別"}
      t.decimal   :price, {scale: 0, precision: 4, null: false, default: 1000, comment: "単価"}

      t.timestamps null: false
    end
    add_index :work_kind_prices, [:term, :work_kind_id], {unique: true}
  end
end
