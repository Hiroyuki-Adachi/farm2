class AddGroupToLands < ActiveRecord::Migration[6.0]
  def change
    add_column :lands, :group_flag, :boolean, {null: false, default: false, comment: "グループフラグ"}
    add_column :lands, :group_id, :integer,   {null: true, comment: "グループID"}
  end
end
