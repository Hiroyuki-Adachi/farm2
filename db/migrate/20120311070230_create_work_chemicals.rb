class CreateWorkChemicals < ActiveRecord::Migration
  def change
    create_table :work_chemicals do |t|
      t.integer :work_id,     {null: false}
      t.integer :chemical_id, {null: false}
      t.integer :quantity,    {null: false, default: 0}
      
      t.timestamps
    end
    add_index :work_chemicals, [:work_id, :chemical_id], {unique: true}
  end
end
