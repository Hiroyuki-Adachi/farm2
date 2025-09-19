# == Schema Information
#
# Table name: task_templates(定型タスク)
#
#  id                              :bigint           not null, primary key
#  active(有効)                    :boolean          default(TRUE), not null
#  annual_month(期日月)            :integer
#  description(説明)               :text             default(""), not null
#  discarded_at(論理削除日時)      :datetime
#  kind(年次/月次)                 :integer          default("annual"), not null
#  monthly_stage(期日週)           :integer          default("w1"), not null
#  months_before_due(事前通知月数) :integer          default(1), not null
#  office_role(役割)               :integer          default("none"), not null
#  priority(優先度)                :integer          default("low"), not null
#  title(タスク名)                 :string(40)       not null
#  year_offset(基準年からのズレ)   :integer          default(0), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  idx_on_kind_annual_month_monthly_stage_5eb8d135fc  (kind,annual_month,monthly_stage)
#
require "test_helper"

class TaskTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
