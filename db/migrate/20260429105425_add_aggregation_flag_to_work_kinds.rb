class AddAggregationFlagToWorkKinds < ActiveRecord::Migration[8.1]
  def change
    add_column :work_kinds, :aggregation_flag, :boolean, default: false, null: false, comment: "集計対象フラグ"
  end
end
