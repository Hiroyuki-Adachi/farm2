class AddViewMonthToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :view_month, :integer, {array: true, null: false, default: [1, 4, 8], comment: "表示切替月"}
  end
end
