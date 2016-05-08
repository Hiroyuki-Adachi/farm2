class CreateChemicalTypes < ActiveRecord::Migration
  def change
    create_table :chemical_types do |t|
      t.string  :name,          {null: false, limit: 20}
      t.integer :display_order, {null: false, default: 1}

      t.timestamps
    end
  end
end
