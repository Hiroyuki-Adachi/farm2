# == Schema Information
#
# Table name: work_categories(作業カテゴリ)
#
#  id                         :bigint           not null, primary key
#  discarded_at(論理削除日時) :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(名称)                 :string(10)       default(""), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
require "test_helper"

class WorkCategoryTest < ActiveSupport::TestCase
  test "未削除の作業ジャンルが1件でも存在する場合" do
    category = work_categories(:category_rice)
    assert_no_difference("WorkGenre.kept.count") do
      assert_no_difference("WorkCategory.kept.count") do
        assert_raises(ActiveRecord::RecordNotDestroyed) do
          category.remove_by_policy!
        end
      end
    end

    assert category.reload.kept?
  end

  test "作業ジャンルが存在するが全て論理削除済み" do
    result = nil
    category = work_categories(:category_discardable)
    assert_no_difference("WorkGenre.kept.count") do
      assert_no_difference("WorkCategory.count") do
        result = category.remove_by_policy!
      end
    end

    assert_equal :discarded, result
    assert category.reload.discarded?
  end

  test "作業ジャンルが1件も存在しない" do
    result = nil
    category = work_categories(:category_deletable)

    assert_difference("WorkCategory.count", -1) do
      result = category.remove_by_policy!
    end
    assert_equal :destroyed, result
    assert_not WorkCategory.exists?(category.id)
  end

  test "物理削除ブレーキ" do
    category = work_categories(:category_rice)
    assert_raises(ActiveRecord::RecordNotDestroyed) { category.destroy! }
    assert category.reload.kept?
  end
end
