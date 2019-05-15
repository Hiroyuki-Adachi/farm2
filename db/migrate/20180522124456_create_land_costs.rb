class CreateLandCosts < ActiveRecord::Migration[4.2]
  def change
    create_table :land_costs, {comment: "土地原価"} do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :land_id,      {null: false, comment: "土地"}
      t.integer :work_type_id, {null: false, comment: "作業分類"}
      t.decimal :cost,         {scale: 1, precision: 7, null: false, default: 0, comment: "原価"}
      t.timestamps null: false
    end
    add_index :land_costs, [:term, :land_id], {unique: true}
  end
end
