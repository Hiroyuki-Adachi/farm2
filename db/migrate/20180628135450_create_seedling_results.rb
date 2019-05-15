class CreateSeedlingResults < ActiveRecord::Migration[4.2]
  def change
    create_table :seedling_results, {comment: "育苗結果"} do |t|
      t.integer :seedling_home_id, {comment: "育苗担当"}
      t.integer :work_result_id, {comment: "作業結果"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}
      t.decimal :quantity, {scale: 0, precision: 3, null: false, default: 0, comment: "苗箱数"}
      t.boolean :disposal_flag, {null: false, default: false, comment: "廃棄フラグ"}

      t.timestamps null: false
    end
    add_index :seedling_results, [:seedling_home_id, :work_result_id, :display_order], {unique: true, name: :seedling_results_2nd_key}
    add_column :organizations, :rice_planting_id, :integer, {null: true, comment: "田植作業種別"}
  end
end
