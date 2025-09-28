# == Schema Information
#
# Table name: task_reads(タスク既読)
#
#  id                         :bigint           not null, primary key
#  last_read_at(最終既読日時) :datetime         default(1970-01-01 00:00:00.000000000 JST +09:00), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  task_id(タスクID)          :bigint           not null
#  worker_id(作業者ID)        :bigint           not null
#
# Indexes
#
#  index_task_reads_on_task_id                (task_id)
#  index_task_reads_on_task_id_and_worker_id  (task_id,worker_id) UNIQUE
#  index_task_reads_on_worker_id              (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (worker_id => workers.id)
#
require "test_helper"

class TaskReadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
