class CreateTotalCostDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :total_cost_details, comment: "集計原価(明細)" do |t|
      t.integer :total_cost_id, null: false, comment: "集計原価"
      t.integer :work_type_id, null: false, comment: "作業分類"
      t.decimal :rate, precision: 6, scale: 2, default: 0, null: false, comment: "割合"
      t.decimal :area, precision: 7, scale: 2, defailt: 0, null: false, comment: "面積(α)"
      t.decimal :cost, {precision: 9, null: true, comment: "原価"}
      t.decimal :base_cost, {precision: 9, scale: 3, null: true, comment: "原価(10α当)"}

      t.timestamps null: false
    end
    add_index :total_cost_details, [:total_cost_id, :work_type_id], {unique: true}
  end
end
