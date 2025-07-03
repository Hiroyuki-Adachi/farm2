class AddOtherFlagToWorkTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :work_types, :other_flag, :boolean, null: false, default: false, comment: "その他フラグ"
    WorkType.where(name: "その他").update_all(other_flag: true)
  end
end
