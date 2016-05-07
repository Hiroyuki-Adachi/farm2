class CreateWorkChemicals < ActiveRecord::Migration
  def self.up
    create_table :work_chemicals do |t|
      t.integer :work_id,     {null: false}
      t.integer :chemical_id, {null: false}
      t.integer :quantity,    {null: false, default: 0}
    end
    add_index :work_chemicals, [:work_id, :chemical_id], {unique: true}
  end

  def self.down
    drop_table :work_chemicals
  end
end
