# == Schema Information
#
# Table name: work_results(作業結果データ)
#
#  id(作業結果データ)         :integer          not null, primary key
#  display_order(表示順)      :integer          default(0), not null
#  fixed_amount(確定作業日当) :decimal(7, )
#  fixed_hours(確定作業時間)  :decimal(5, 1)
#  fixed_price(確定作業単価)  :decimal(5, )
#  hours(作業時間)            :decimal(5, 1)    default(0.0), not null
#  remarks(備考)              :string(20)       default(""), not null
#  uuid(UUID(カレンダー用))   :uuid
#  created_at                 :datetime
#  updated_at                 :datetime
#  health_id(健康)            :integer          default(0), not null
#  work_id(作業)              :integer
#  worker_id(作業者)          :integer
#
# Indexes
#
#  index_work_results_on_work_id_and_worker_id  (work_id,worker_id) UNIQUE
#
FactoryBot.define do
  factory :work_result do
    work
    worker
    hours { 6 }
    display_order { 1 }
  end
end
