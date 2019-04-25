class AddUrlToOrganizations < ActiveRecord::Migration[4.2]
  def up
    add_column :organizations, :url, :string, {null: true, comment: "URL"}
  end

  def down
    remove_column :organizations, :url
  end
end
