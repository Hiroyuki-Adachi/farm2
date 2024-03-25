class AddTermToPlanLands < ActiveRecord::Migration[7.1]
  def up
    add_column :plan_lands, :term, :integer, limit: 4, null: false, default: 0, comment: "年度"
    remove_index :plan_lands, name: "plan_lands_2nd"
    add_index :plan_lands, [:user_id, :land_id, :term], unique: true, name: "plan_lands_2nd"
  end

  def down
    remove_index :plan_lands, name: "plan_lands_2nd"
    remove_column :plan_lands, :term
    add_index :plan_lands, [:user_id, :land_id], unique: true, name: "plan_lands_2nd"
  end
end
