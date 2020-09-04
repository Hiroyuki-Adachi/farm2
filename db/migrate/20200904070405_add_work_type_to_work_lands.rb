class AddWorkTypeToWorkLands < ActiveRecord::Migration[6.0]
  def change
    add_column :work_lands, :work_type_id, :integer, {null: true, comment: "作業分類"}
  end
end
