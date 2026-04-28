class RemoveTargetPeriodColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :systems, :target_from, :date
    remove_column :systems, :target_to, :date
    remove_column :users, :target_from, :date, null: false, default: "2010-01-01"
    remove_column :users, :target_to, :date, null: false, default: "2010-12-31"
  end
end
