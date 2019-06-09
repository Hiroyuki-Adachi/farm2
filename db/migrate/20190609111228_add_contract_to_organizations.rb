class AddContractToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :contract_work_type_id, :integer, {null: true, comment: "受託作業分類"}
  end
end
