class DropIndexTermOfSystems < ActiveRecord::Migration[7.1]
  def up
    remove_index :systems, column: :term
  end

  def down
    add_index :systems, :term, unique: true
  end
end
