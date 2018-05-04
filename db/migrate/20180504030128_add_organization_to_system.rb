class AddOrganizationToSystem < ActiveRecord::Migration
  def up
    add_column :systems, :organization_id, :integer, {null: true, comment: "組織"}
    System.all.each do |system|
      system.organization_id = Organization.first.id
      system.save!
    end
  end

  def down
    remove_column :systems, :organization_id
  end
end
