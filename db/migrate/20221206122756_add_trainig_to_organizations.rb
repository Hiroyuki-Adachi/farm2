class AddTrainigToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :training_id, :integer, null: true, comment: "訓練id"
  end
end
