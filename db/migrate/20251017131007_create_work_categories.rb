class CreateWorkCategories < ActiveRecord::Migration[8.0]
  def up
    create_table :work_categories, comment: '作業カテゴリ' do |t|
      t.string   :name, null: false, limit: 10, default: '', comment: "名称"
      t.integer  :display_order, null: false, default: 0, comment: "表示順"
      t.datetime :discarded_at, comment: '論理削除日時'
      t.timestamps
    end

    WorkCategory.reset_column_information
    WorkType.where(category_flag: true).order(:display_order).find_each do |wt|
      WorkCategory.create!(
        name: wt.name,
        display_order: wt.display_order / 10
      )
    end
  end

  def down
    drop_table :work_categories
  end
end
