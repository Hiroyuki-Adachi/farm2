class CreateDepreciations < ActiveRecord::Migration[4.2]
  def change
    create_table :depreciations, {comment: "減価償却"} do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.integer :machine_id, {comment: "機械"}
      t.decimal :cost, {precision: 9, null: false, default: 0, comment: "減価償却費"}

      t.timestamps null: false
    end
    add_index :depreciations, [:term, :machine_id], {unique: true}
  end
end
