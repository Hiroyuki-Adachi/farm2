class AddOwnerFlagToHome < ActiveRecord::Migration
  def up
    add_column :homes, :owner_flag, :boolean, {null: false, default: false, comment: "所有者フラグ"}
    Home.where(company_flag: true).update_all(owner_flag: true)
    Home.where(["section_id <= ?", 6]).update_all(owner_flag: true)
  end

  def down
    remove_column :homes, :owner_flag
  end
end
