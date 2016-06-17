class CreateMachineResults < ActiveRecord::Migration
  def change
    create_table :machine_results, {comment: "機械稼動データ"} do |t|
      t.integer :machine_id,      {comment: "機械"}
      t.integer :work_result_id,  {comment: "作業結果データ"}
      t.integer :display_order,   {null: false, default: 1, comment: "表示順"}
      t.decimal :hours,           {null: false, default: 0, precision: 3, scale: 1, comment: "稼動時間"}
      t.decimal :fixed_quantity,  {null: true, precision: 6, scale: 2, comment: "確定稼動量"}
      t.integer :fixed_adjust_id, {null: true, comment: "確定稼動単位"}
      t.decimal :fixed_price,     {scale: 0, precision: 5, null: true, comment: "確定稼動単価"}
      t.decimal :fixed_amount,    {scale: 0, precision: 7, null: true, comment: "確定使用料"}

      t.timestamps
    end
    add_index :machine_results, [:machine_id, :work_result_id], {unique: true}
  end
end
