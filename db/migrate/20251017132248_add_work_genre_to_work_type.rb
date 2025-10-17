class AddWorkGenreToWorkType < ActiveRecord::Migration[8.0]
  def up
    add_reference :work_types, :work_genre, foreign_key: true, comment: "作業ジャンル"
    WorkType.reset_column_information
    WorkType.find_each do |work_type|
      work_type_genre = WorkType.find_by(genre: work_type.genre, category_flag: true)
      next unless work_type_genre
      genre = WorkGenre.find_by(name: work_type_genre.name)
      next unless genre
      work_type.update!(work_genre_id: genre.id)
    end
    WorkType.where(work_genre_id: nil).update_all(work_genre_id: WorkGenre.first.id)
    change_column_null :work_types, :work_genre_id, false
    WorkType.where(category_flag: true).discard_all
    remove_column :work_types, :genre
    remove_column :work_types, :category_flag
  end

  def down
    add_column :work_types, :genre, :integer, null: false, default: 0, comment: "作業ジャンル"
    add_column :work_types, :category_flag, :boolean, null: false, default: false, comment: "カテゴリフラグ"
    WorkType.reset_column_information
    WorkType.find_each do |work_type|
      genre = WorkGenre.find(work_type.work_genre.id)
      work_type.update!(genre: genre.id, category_flag: (genre.name == work_type.name))
      work_type.undiscard if work_type.category_flag
    end
    remove_reference :work_types, :work_genre, foreign_key: true
  end
end
