class CreateWorkChemicals < ActiveRecord::Migration
  def change
    create_table :work_chemicals, {comment: "薬剤使用データ"} do |t|
      t.integer :work_id,     {null: false, comment: "作業"}
      t.integer :chemical_id, {null: false, comment: "薬剤"}
      t.decimal :quantity,    {scale: 0, precision: 3, null: false, default: 0, comment: "使用料"}
      
      t.timestamps
    end
    add_index :work_chemicals, [:work_id, :chemical_id], {unique: true}
  end
end
