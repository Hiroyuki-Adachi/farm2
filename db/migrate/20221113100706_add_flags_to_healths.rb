class AddFlagsToHealths < ActiveRecord::Migration[7.0]
  def change
    add_column :healths, :well_flag,  :boolean, null: false, default: false, comment: "健康フラグ"
    add_column :healths, :other_flag, :boolean, null: false, default: false, comment: "その他フラグ"

    Health.find(0).update(well_flag: true)
    Health.find(4).update(other_flag: true)
  end
end
