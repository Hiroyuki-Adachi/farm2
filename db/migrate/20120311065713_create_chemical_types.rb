class CreateChemicalTypes < ActiveRecord::Migration
  def self.up
    create_table :chemical_types do |t|
      t.string  :name,          {null: false, limit: 20}
      t.integer :display_order, {null: false, default: 1}

      t.timestamps
    end
  end

  def self.down
    drop_table :chemical_types
  end
end
