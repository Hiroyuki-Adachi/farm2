class AddOrganizationIdToHomes < ActiveRecord::Migration[8.1]
  def change
    add_column :homes, :organization_id, :integer, default: 1, null: false, comment: "組織"
    add_index  :homes, :organization_id
  end
end
