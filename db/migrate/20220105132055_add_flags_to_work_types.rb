class AddFlagsToWorkTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :work_types, :work_flag, :boolean, null: false, default: true, comment: "日報フラグ"
  end
end
