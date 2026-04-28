# == Schema Information
#
# Table name: seedling_results(育苗結果)
#
#  id(育苗結果)               :integer          not null, primary key
#  disposal_flag(廃棄フラグ)  :boolean          default(FALSE), not null
#  quantity(苗箱数)           :decimal(3, )     default(0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  seedling_home_id(育苗担当) :integer
#  work_result_id(作業結果)   :integer
#
require 'test_helper'

class SeedlingResultTest < ActiveSupport::TestCase
  test "育苗使用画面順" do
    seedling_home = seedling_homes(:seedling_home1)

    same_work_first = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_result_taue1),
      quantity: 10
    )
    earlier_work = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_results300),
      quantity: 20
    )
    same_work_second = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_result_taue2),
      quantity: 30
    )

    assert_equal(
      [earlier_work.id, same_work_first.id, same_work_second.id],
      seedling_home.seedling_results.for_seedling_use.limit(3).ids
    )
  end
end
