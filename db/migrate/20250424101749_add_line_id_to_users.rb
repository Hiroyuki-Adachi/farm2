class AddLineIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :line_id, :string, limit: 50, null: false, default: ""
  end
end
