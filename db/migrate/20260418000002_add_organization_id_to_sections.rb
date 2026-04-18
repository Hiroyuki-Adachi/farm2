class AddOrganizationIdToSections < ActiveRecord::Migration[8.1]
  def change
    add_column :sections, :organization_id, :integer, default: 1, null: false, comment: "組織"
    add_index  :sections, :organization_id
  end
end
