class RenameFromTermToActiveDateOnLandCosts < ActiveRecord::Migration[4.2]
  def up
    remove_index :land_costs, [:term, :land_id]
    add_column :land_costs, :activated_on, :date, {null: false, default: '1900-01-01', comment: "有効日"}
    LandCost.all.each do |land_cost|
      land_cost.update(activated_on: Date.new(land_cost.term, 1, 1))
    end
    remove_column :land_costs, :term
    add_index :land_costs, [:activated_on, :land_id], {unique: true}
  end

  def down
    remove_index :land_costs, [:activated_on, :land_id]
    add_column :land_costs, :term, :integer, {limit: 4, null: false, default: 2000, comment: "年度(期)"}
    LandCost.all.each do |land_cost|
      land_cost.update(term: land_cost.activated_on.year)
    end
    remove_column :land_costs, :activated_on
    add_index :land_costs, [:term, :land_id], {unique: true}
  end
end
