class AddAllocationModeToSorimachiJournals < ActiveRecord::Migration[8.1]
  def change
    add_column :sorimachi_journals, :allocation_mode, :integer, default: 0, null: false
    add_index :sorimachi_journals, [:term, :allocation_mode]
  end
end
