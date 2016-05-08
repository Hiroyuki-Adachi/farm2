class CreateChemicalKinds < ActiveRecord::Migration
  def change
    create_table :chemical_kinds do |t|
      t.integer :chemical_type_id,  {null: false}
      t.integer :work_kind_id,      {null: false}
    end
    add_index :chemical_kinds, [:chemical_type_id, :work_kind_id], {unique: true}
  end
end
