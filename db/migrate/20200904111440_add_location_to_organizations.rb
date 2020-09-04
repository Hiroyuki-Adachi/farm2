class AddLocationToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :location, :point, {null: false, default: [35, 135], comment: "位置"}
  end
end
