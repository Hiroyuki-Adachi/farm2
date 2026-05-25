class AddTruckIdToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :truck_id, :integer, null: true, comment: "軽トラID"
  end
end
