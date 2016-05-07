class CreateChemicals < ActiveRecord::Migration
  def self.up
    create_table :chemicals do |t|
      t.string  :name,              {null: false, limit: 20}
      t.integer :display_order,     {null: false, default: 0}
      t.integer :chemical_type_id,  {null: false}

      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :chemicals
  end
end
