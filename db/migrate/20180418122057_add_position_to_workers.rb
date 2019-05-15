class AddPositionToWorkers < ActiveRecord::Migration[4.2]
  def up
    add_column :workers, :position_id, :integer, {null: false, default: 0, comment: "役職"}
  end

  def down
    remove_column :workers, :position_id
  end
end
