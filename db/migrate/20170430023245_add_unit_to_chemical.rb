class AddUnitToChemical < ActiveRecord::Migration
  def up
    add_column :chemicals, :unit, :string, {null: false, limit: 2, default: '袋', comment: "単位"}
  end

  def down
    remove_column :chemicals, :unit
  end
end
