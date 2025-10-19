# == Schema Information
#
# Table name: work_genres(作業ジャンル)
#
#  id                             :bigint           not null, primary key
#  discarded_at(論理削除日時)     :datetime
#  display_order(表示順)          :integer          default(0), not null
#  name(名称)                     :string(10)       default(""), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  work_category_id(作業カテゴリ) :bigint           not null
#
# Indexes
#
#  index_work_genres_on_work_category_id  (work_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_category_id => work_categories.id)
#
require "test_helper"

class WorkGenreTest < ActiveSupport::TestCase
  test "未削除の作業分類が1件でも存在する場合" do
    genre = work_genres(:genre_rice)
    assert_no_difference("WorkType.kept.count") do
      assert_no_difference("WorkGenre.kept.count") do
        assert_raises(ActiveRecord::RecordNotDestroyed) do
          genre.remove_by_policy!
        end
      end
    end

    assert genre.reload.kept?
  end

  test "作業分類が存在するが全て論理削除済み" do
    result = nil
    genre = work_genres(:genre_discardable)
    assert_no_difference("WorkType.kept.count") do
      assert_no_difference("WorkGenre.count") do
        result = genre.remove_by_policy!
      end
    end

    assert_equal :discarded, result
    assert genre.reload.discarded?
  end

  test "作業分類が1件も存在しない" do
    result = nil
    genre = work_genres(:genre_deletable)

    assert_difference("WorkGenre.count", -1) do
      result = genre.remove_by_policy!
    end
    assert_equal :destroyed, result
    assert_not WorkGenre.exists?(genre.id)
  end

  test "物理削除ブレーキ" do
    genre = work_genres(:genre_rice)
    assert_raises(ActiveRecord::RecordNotDestroyed) { genre.destroy! }
    assert genre.reload.kept?
  end
end
