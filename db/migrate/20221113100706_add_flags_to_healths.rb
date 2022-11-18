class AddFlagsToHealths < ActiveRecord::Migration[7.0]
  def change
    add_column :healths, :well_flag,  :boolean, null: false, default: false, comment: "健康フラグ"
    add_column :healths, :other_flag, :boolean, null: false, default: false, comment: "その他フラグ"
    add_column :machines, :number, :integer, null: true,  comment: "番号"
    add_column :machine_types, :code, :string, limit: 1, null: false, default: "",  comment: "種別コード"
    add_column :organizations, :maintenance_id, :integer, null: true, comment: "機械保守id"
    add_column :organizations, :cleaning_id, :integer, null: true, comment: "清掃id"

    Health.find(0).update(well_flag: true)
    Health.find(4).update(other_flag: true)
  end
end
