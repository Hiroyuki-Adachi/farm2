class AddStrawToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :straw_id, :integer, null: true, comment: "稲わらid"
  end
end
