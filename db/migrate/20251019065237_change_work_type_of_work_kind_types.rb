class ChangeWorkTypeOfWorkKindTypes < ActiveRecord::Migration[8.0]
  def up
    add_reference :work_kind_types, :work_category, foreign_key: true, comment: "作業カテゴリ"
    WorkKindType.reset_column_information
    WorkKindType.find_each do |work_kind_type|
      work_type = WorkType.find(work_kind_type.work_type_id)
      work_kind_type.update!(work_category_id: work_type.genre.work_category_id)
    end
    change_column_null :work_kind_types, :work_category_id, false
    remove_column :work_kind_types, :work_type_id
  end

  def down
    add_column :work_kind_types, :work_type_id, :bigint, default: 0, null: false, comment: "作業種類"
    WorkKindType.reset_column_information
    WorkKindType.find_each do |work_kind_type|
      work_category = WorkCategory.find(work_kind_type.work_category_id)
      work_type = WorkType.find_by(name: work_category.name)
      work_kind_type.update!(work_type_id: work_type.id)
    end
    remove_reference :work_kind_types, :work_category, foreign_key: true
  end
end
