class CreateCleanings < ActiveRecord::Migration[7.0]
  def change
    create_table :cleanings, comment: "清掃" do |t|
      t.integer :work_id,             null: false, comment:"作業ID"
      t.string  :target,  limit: 20,  null: false, default: "", comment: "駆除対象"
      t.string  :method,  limit: 20,  null: false, default: "", comment: "清掃方法"
      t.timestamps
    end
  end
end
