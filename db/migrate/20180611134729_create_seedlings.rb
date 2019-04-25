class CreateSeedlings < ActiveRecord::Migration[4.2]
  def change
    create_table :seedlings, {comment: "育苗"} do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :work_type_id, {comment: "作業分類"}
      t.decimal :seedling_quantity, {scale: 0, precision: 4, null: false, default: 0, comment: "苗箱数"}
      t.decimal :soil_quantity, {scale: 0, precision: 4, null: false, default: 0, comment: "育苗土数"}
      t.decimal :seed_cost, {scale: 0, precision: 6, null: false, default: 0, comment: "種子原価"}

      t.timestamps null: false
    end
    add_index :seedlings, [:term, :work_type_id], {unique: true}
  end
end
