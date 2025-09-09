# == Schema Information
#
# Table name: task_watchers(タスク閲覧者)
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  task_id(タスクID)   :bigint           not null
#  worker_id(閲覧者ID) :bigint           not null
#
# Indexes
#
#  index_task_watchers_on_task_id                (task_id)
#  index_task_watchers_on_worker_id              (worker_id)
#  index_task_watchers_on_worker_id_and_task_id  (worker_id,task_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (worker_id => workers.id)
#
require "test_helper"

class TaskWatcherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
