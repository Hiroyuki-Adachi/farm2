# == Schema Information
#
# Table name: work_kinds # 作業種別マスタ
#
#  id            :integer          not null, primary key    # 作業種別マスタ
#  name          :string(20)       not null                 # 作業種別名称
#  display_order :integer          not null                 # 表示順
#  other_flag    :boolean          default(FALSE), not null # その他フラグ
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  land_flag     :boolean          default(TRUE), not null  # 土地利用フラグ
#

require 'test_helper'

class WorkKindTest < ActiveSupport::TestCase
  test "各年の単価設定" do
    work_kind = WorkKind.find(work_kinds(:work_kind_every_term).id) 
    assert_equal 2010, work_kind.term_price(2010)
    assert_equal 2015, work_kind.term_price(2015)
  end

  test "初年度のみ単価設定" do
    work_kind = WorkKind.find(work_kinds(:work_kind_first_term).id) 
    assert_equal work_kind_prices(:work_kind_prices_first_0).price, work_kind.term_price(2010)
    assert_equal work_kind_prices(:work_kind_prices_first_0).price, work_kind.term_price(2015)
  end
end
