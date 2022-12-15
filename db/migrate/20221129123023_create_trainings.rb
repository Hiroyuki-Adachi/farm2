class CreateTrainings < ActiveRecord::Migration[7.0]
  def change
    create_table :trainings, comment: "訓練" do |t|
      t.integer :work_id,               null: false,  comment: "作業ID"
      t.integer :schedule_id,           null: true,   comment: "訓練ID"
      t.integer :worker_id,             null: false,  comment: "講師(作業者ID)"
      t.string  :content,   limit: 20,  null: false,  default: "", comment: "内容"
      t.string  :document,  limit: 40,  null: false,  default: "", comment: "資料"
      t.string  :training_place,  limit: 20,  null: false,  default: "", comment: "研修場所"
      t.string  :studying_place,  limit: 20,  null: false,  default: "", comment: "学習場所"
      t.text    :remarks,               null: false,  default: "", comment: "備考"

      t.timestamps
    end
  end
end
