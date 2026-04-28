class RemoveDisplayOrderFromSeedlingResults < ActiveRecord::Migration[8.1]
  def change
    remove_column :seedling_results, :display_order, :integer, default: 0, null: false, comment: "表示順"
  end
end
