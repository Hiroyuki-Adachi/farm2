class CreateChemicals < ActiveRecord::Migration
  def change
    create_table :chemicals do |t|
      t.string  :name,              {null: false, limit: 20}
      t.integer :display_order,     {null: false, default: 0}
      t.integer :chemical_type_id,  {null: false}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :chemicals, :deleted_at
  end
end
