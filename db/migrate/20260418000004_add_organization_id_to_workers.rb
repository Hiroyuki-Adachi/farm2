class AddOrganizationIdToWorkers < ActiveRecord::Migration[8.1]
  def change
    add_column :workers, :organization_id, :integer, default: 1, null: false, comment: "組織"
    add_index  :workers, :organization_id
  end
end
