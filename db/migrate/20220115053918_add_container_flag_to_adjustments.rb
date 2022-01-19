class AddContainerFlagToAdjustments < ActiveRecord::Migration[6.1]
  def change
    add_column :adjustments, :container_flag, :boolean, null: false, default: false, comment: "フレコンフラグ"
    add_column :adjustments, :waste_date, :date, null: true, comment: "くず米出荷日"
  end
end
