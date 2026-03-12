class AddIconUpdatedAtToWorkTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :work_types, :icon_updated_at, :datetime, null: true
    WorkType.where.not(icon: nil).update_all(icon_updated_at: Time.current)
  end
end
