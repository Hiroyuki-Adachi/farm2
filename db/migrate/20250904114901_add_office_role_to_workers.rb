class AddOfficeRoleToWorkers < ActiveRecord::Migration[8.0]
  def change
    add_column :workers, :office_role, :integer, null: false, default: 0, comment: "事務の役割"
  end
end
