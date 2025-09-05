class AddOfficeRoleToWorkTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :work_types, :office_role, :integer, null: false, default: 0, comment: "事務の役割"
  end
end
