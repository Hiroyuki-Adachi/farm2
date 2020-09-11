class CreatePlanSeedlings < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_seedlings, {comment: "育苗計画"} do |t|
      t.integer :plan_work_type_id, {null: false, comment: "作業計画"}
      t.integer :home_id, {comment: "世帯"}
      t.decimal :quantity, {scale: 0, precision: 4, null: false, default: 0, comment: "枚数"}
      t.decimal :seeds, {scale: 0, precision: 3, null: false, default: 0, comment: "種子(kg)"}
      t.decimal :seed_bag1, {scale: 0, precision: 2, null: false, default: 0, comment: "種子(大袋)"}
      t.decimal :seed_bag2, {scale: 0, precision: 2, null: false, default: 0, comment: "種子(小袋)"}
      t.decimal :soil_bag, {scale: 0, precision: 4, null: false, default: 0, comment: "育苗土(袋)"}

      t.timestamps
    end
    add_index :plan_seedlings, [:plan_work_type_id, :home_id], {unique: true, name: "plan_seedlings_2nd"}
  end
end
