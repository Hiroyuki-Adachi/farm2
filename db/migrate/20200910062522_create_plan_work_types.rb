class CreatePlanWorkTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_work_types, {comment: "作業計画"} do |t|
      t.integer :work_type_id, {null: false, comment: "作業分類"}
      t.decimal :area, {scale: 2, precision: 7, null: false, default: 0, comment: "面積(α)"}
      t.integer :month, {null: false, default: 0, comment: "開始月"}
      t.decimal :unit, {scale: 1, precision: 3, null: false, default: 0, comment: "枚数(10a当)"}
      t.decimal :quantity, {scale: 0, precision: 5, null: false, default: 0, comment: "枚数"}
      t.decimal :between_stocks, {scale: 0, precision: 2, null: false, default: 0, comment: "株間(cm)"}
      t.decimal :seeds, {scale: 0, precision: 3, null: false, default: 0, comment: "種子(1枚当g)"}
      t.decimal :soils, {scale: 2, precision: 4, null: false, default: 0, comment: "育苗土(1枚当袋)"}
      t.decimal :bag_weight1, {scale: 1, precision: 3, null: false, default: 0, comment: "大袋(kg)"}
      t.decimal :bag_weight2, {scale: 1, precision: 3, null: false, default: 0, comment: "小袋(kg)"}

      t.timestamps
    end
    add_index :plan_work_types, [:work_type_id], {unique: true, name: "plan_work_types_2nd"}
  end
end
