class AddSeedlingToSystems < ActiveRecord::Migration[4.2]
  def change
    add_column :systems, :seedling_price, :decimal, {scale: 0, precision: 4, null: false, default: 0, comment: "育苗費"}
    add_column :systems, :seedling_chemical_id, :integer, {null: true, default: 0, comment: "育苗土"}
  end
end
