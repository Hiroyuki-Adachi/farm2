class RemoveIndexSeedlingAndHomeOfSeedlingHomes < ActiveRecord::Migration[8.0]
  def up
    remove_index :seedling_homes, [:seedling_id, :home_id]
  end

  def down
    add_index :seedling_homes, [:seedling_id, :home_id], unique: true
  end
end
