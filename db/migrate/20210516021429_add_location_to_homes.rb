class AddLocationToHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :homes, :location, :point, {null: true, comment: "位置"}
  end
end
