class AddContractToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :contract_work_type_id, :integer, {null: true, comment: "受託作業分類"}
    add_column :work_lands, :fixed_cost, :decimal, {scale: 0, precision: 6, null: true, comment: "確定作業原価"}
  end
end
