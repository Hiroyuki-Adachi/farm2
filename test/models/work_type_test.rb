# == Schema Information
#
# Table name: work_types
#
#  id(作業分類マスタ)              :integer          not null, primary key
#  bg_color(背景色)                :string(8)
#  category_flag(カテゴリーフラグ) :boolean          default(FALSE)
#  cost_flag(原価フラグ)           :boolean          default(FALSE), not null
#  deleted_at                      :datetime
#  display_order(表示順)           :integer          default(0), not null
#  genre(作業ジャンル)             :integer          not null
#  icon(アイコン)                  :binary
#  icon_name(アイコン名)           :string(40)
#  land_flag(土地利用)             :boolean          default(TRUE), not null
#  name(作業分類名称)              :string(10)       not null
#  work_flag(日報フラグ)           :boolean          default(TRUE), not null
#
# Indexes
#
#  index_work_types_on_deleted_at  (deleted_at)
#
require 'test_helper'

class WorkTypeTest < ActiveSupport::TestCase

  test "作業分類年度別マスタ連携" do
    # 削除パターン
    work_type = WorkType.find(work_types(:work_types17).id)
    work_type.term = 2015
    work_type.term_flag = false

    assert_difference 'WorkTypeTerm.count', -1 do
      work_type.save
    end

    # 更新パターン
    work_type.term = 2015
    work_type.term_flag = true

    assert_difference 'WorkTypeTerm.count' do
      work_type.save
    end

    # 追加パターン
    work_type.term = 2016
    work_type.term_flag = true

    assert_difference 'WorkTypeTerm.count', 1 do
      work_type.save
    end
  end

  test "作業分類年度別マスタチェック" do
    work_type = WorkType.find(work_types(:work_types17).id)
    assert work_type.exists_term?(2015)
    assert_not work_type.exists_term?(2016)
  end
end
