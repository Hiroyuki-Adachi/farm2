class ChangeCalendarUuidsToUuid < ActiveRecord::Migration[8.1]
  def up
    change_column :schedule_workers, :uuid, :uuid, using: "uuid::uuid"
    change_column :work_results, :uuid, :uuid, using: "uuid::uuid"
  end

  def down
    change_column :schedule_workers, :uuid, :string, limit: 36, using: "uuid::text"
    change_column :work_results, :uuid, :string, limit: 36, using: "uuid::text"
  end
end
