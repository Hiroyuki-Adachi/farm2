class AddWorkWholeCropToTotalCosts < ActiveRecord::Migration[5.2]
  def change
    add_column :total_costs, :whole_crop_land_id, :integer, {null: true, comment: "WCS土地"}
  end
end
