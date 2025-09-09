# == Schema Information
#
# Table name: tasks(タスク)
#
#  id                   :bigint           not null, primary key
#  description(説明)    :text             default(""), not null
#  due_on(期限)         :date
#  end_reason(完了理由) :integer          default("unset"), not null
#  ended_on(完了日)     :date
#  office_role(役割)    :integer          default("none"), not null
#  priority(優先度)     :integer          default("low"), not null
#  started_on(着手日)   :date
#  title(タスク名)      :string(64)       default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assignee_id(担当者)  :bigint
#  creator_id(作成者)   :bigint
#  task_status_id(状態) :integer          default(0), not null
#
# Indexes
#
#  index_tasks_on_assignee_id  (assignee_id)
#  index_tasks_on_creator_id   (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => workers.id)
#  fk_rails_...  (creator_id => workers.id)
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
