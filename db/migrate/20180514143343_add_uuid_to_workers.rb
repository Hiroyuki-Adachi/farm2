class AddUuidToWorkers < ActiveRecord::Migration
  def up
    add_column :work_results,     :uuid, :string, {null: true, limit: 36, comment: "UUID(カレンダー用)"}
    add_column :schedule_workers, :uuid, :string, {null: true, limit: 36, comment: "UUID(カレンダー用)"}
    WorkResult.all.each do |worker|
      worker.set_uuid
      worker.save!
    end
    ScheduleWorker.all.each do |worker|
      worker.set_uuid
      worker.save!
    end
  end

  def down
    remove_column :work_results,     :uuid
    remove_column :schedule_workers, :uuid
  end
end
