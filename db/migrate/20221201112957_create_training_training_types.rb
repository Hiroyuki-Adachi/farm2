class CreateTrainingTrainingTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :training_training_types, comment: "訓練訓練種別" do |t|
      t.integer :training_id, null: false, comment: "訓練ID"
      t.integer :training_type_id, null: false, comment: "訓練訓練ID"

      t.timestamps
    end
    add_index :training_training_types, [:training_id, :training_type_id], unique: true, name: :training_training_types_2nd
  end
end
