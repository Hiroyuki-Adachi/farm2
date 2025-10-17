class CreateWorkGenres < ActiveRecord::Migration[8.0]
  class MWorkCategory < ApplicationRecord; self.table_name = "work_categories"; end

  def up
    create_table :work_genres, comment: '作業ジャンル' do |t|
      t.string    :name, null: false, limit: 10, default: '', comment: "名称"
      t.integer   :display_order, null: false, default: 0, comment: "表示順"
      t.references :work_category, null: false, foreign_key: true, comment: "作業カテゴリ"
      t.datetime :discarded_at, null: true, comment: '論理削除日時'

      t.timestamps
    end

    WorkGenre.reset_column_information
    MWorkCategory.all.order(:display_order).each do |category|
      WorkGenre.create!(
        name: category.name,
        display_order: category.display_order,
        work_category_id: category.id
      )
    end
  end

  def down
    drop_table :work_genres
  end
end
