class AddUrlToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :url, :string, {null: true, comment: "URL"}
  end

  def down
    remove_column :organizations, :url
  end
end
