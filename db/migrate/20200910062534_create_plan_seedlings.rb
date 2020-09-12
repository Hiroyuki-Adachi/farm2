class CreatePlanSeedlings < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_seedlings, {comment: "育苗計画"} do |t|
      t.integer :plan_work_type_id, {null: false, comment: "作業計画"}
      t.integer :home_id, {comment: "世帯"}
      t.decimal :quantity, {scale: 0, precision: 4, null: false, default: 0, comment: "枚数"}

      t.timestamps
    end
    add_index :plan_seedlings, [:plan_work_type_id, :home_id], {unique: true, name: "plan_seedlings_2nd"}
  end
end
