class CreateChemicalWorkTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :chemical_work_types, {comment: "薬剤使用量"} do |t|
      t.integer :chemical_term_id, {comment: "薬剤利用"}
      t.integer :work_type_id, {comment: "作業分類"}
      t.decimal :quantity, {scale: 1, precision: 5, null: false, default: 0, comment: "使用量"}

      t.timestamps null: false
    end
    add_index :chemical_work_types, [:chemical_term_id, :work_type_id], {unique: true}
  end
end
