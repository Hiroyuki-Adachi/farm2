class AddInfoToMachines < ActiveRecord::Migration[7.0]
  def change
    add_column :machines, :number, :integer, null: true,  comment: "番号"
    add_column :machine_types, :code, :string, limit: 1, null: false, default: "",  comment: "種別コード"
    add_column :organizations, :maintenance_id, :integer, null: true, comment: "機械保守id"
  end
end
