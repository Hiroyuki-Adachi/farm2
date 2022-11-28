class CreateCleaningCleaningTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :cleaning_cleaning_targets, comment: "清掃対象" do |t|
      t.references  :cleaning,            comment: "清掃"
      t.integer     :cleaning_target_id,  comment: "清掃対象ID"

      t.timestamps
    end
  end
end
