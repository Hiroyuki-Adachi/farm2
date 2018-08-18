class CreateWorkResults < ActiveRecord::Migration
  def change
    create_table :work_results, {comment: "作業結果データ"} do |t|
      t.integer :work_id,       {comment: "作業"}
      t.integer :worker_id,     {comment: "作業者"}
      t.decimal :hours,         {scale: 1, precision: 5, null: false, default: 0, comment: "作業時間"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}
      t.decimal :fixed_hours,   {scale: 1, precision: 5, null: true, comment: "確定作業時間"}
      t.decimal :fixed_price,   {scale: 0, precision: 5, null: true, comment: "確定作業単価"}
      t.decimal :fixed_amount,  {scale: 0, precision: 7, null: true, comment: "確定作業日当"}

      t.timestamps
    end
    add_index :work_results, [:work_id, :worker_id], {unique: true}
  end
end
