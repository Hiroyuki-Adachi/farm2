class AddUserToPlanLands < ActiveRecord::Migration[6.1]
  def up
    add_column :plan_lands, :user_id, :integer,  {null: false, default: 0, comment: "利用者"}
    remove_index :plan_lands, {name: "plan_lands_2nd"}
    add_index :plan_lands, [:user_id, :land_id], {unique: true, name: "plan_lands_2nd"}
  end

  def down
    remove_index :plan_lands, {name: "plan_lands_2nd"}
    remove_column :plan_lands, :user_id
    add_index :plan_lands, [:land_id], {unique: true, name: "plan_lands_2nd"}
  end
end
