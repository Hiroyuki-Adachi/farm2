class CreatePlanLands < ActiveRecord::Migration[6.0]
  def change
    create_table :plan_lands, {id: false, comment: "作付計画"} do |t|
      t.integer :land_id, {null: false, comment: "土地"}
      t.integer :work_type_id, {null: false, comment: "作業分類"}
      t.timestamps
    end
    add_index :plan_lands, [:land_id], {unique: true, name: "plan_lands_2nd"}
  end
end
