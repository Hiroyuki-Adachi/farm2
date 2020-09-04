class AddRegionToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :region, :polygon, {null: true, comment: "領域"}
  end
end
