class CreateTotalCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :total_costs, comment: "集計原価" do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :total_cost_type_id, {null: false, comment: "集計原価種別"}
      t.date :occurred_on, {null: false, comment: "発生日"}
      t.integer :work_id, {null: true, comment: "作業"}
      t.integer :expense_id, {null: true, comment: "経費"}
      t.integer :depreciation_id, {null: true, comment: "減価償却"}
      t.integer :work_chemical_id, {null: true, comment: "薬剤使用"}
      t.decimal :amount, {precision: 9, default: "0", null: false, comment: "原価額"}

      t.timestamps null: false
    end
    add_index :total_costs, [:term, :occurred_on], {unique: false}
  end
end
