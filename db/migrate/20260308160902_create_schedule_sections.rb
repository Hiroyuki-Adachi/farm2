class CreateScheduleSections < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_sections, id: false, comment: "作業予定班" do |t|
      t.integer :schedule_id, null: false, comment: "作業予定"
      t.integer :section_id, null: false, comment: "班"
    end

    execute "ALTER TABLE schedule_sections ADD PRIMARY KEY (schedule_id, section_id)"
  end
end
