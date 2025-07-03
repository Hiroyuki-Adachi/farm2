# == Schema Information
#
# Table name: schedules(作業予定)
#
#  id(作業予定)                               :integer          not null, primary key
#  calendar_remove_flag(カレンダー削除フラグ) :boolean          default(FALSE), not null
#  end_at(終了予定時刻)                       :time             default(2000-01-01 17:00:00.000000000 JST +09:00), not null
#  farming_flag(営農フラグ)                   :boolean          default(TRUE), not null
#  line_flag(LINEフラグ)                      :boolean          default(TRUE), not null
#  minutes_flag(議事録フラグ)                 :boolean          default(TRUE), not null
#  name(作業名称)                             :string(40)       not null
#  start_at(開始予定時刻)                     :time             default(2000-01-01 08:00:00.000000000 JST +09:00), not null
#  term(年度(期))                             :integer          not null
#  work_flag(作業フラグ)                      :boolean          default(TRUE), not null
#  worked_at(作業予定日)                      :date             not null
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  work_kind_id(作業種別)                     :integer          default(0), not null
#  work_type_id(作業分類)                     :integer
#

class Schedule < ApplicationRecord
  validates :worked_at, presence: true
  validates :name, length: {maximum: 40}, if: proc { |x| x.name.present?}

  DISPLAY_DAYS = 30

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}

  has_many :schedule_workers, -> {order('schedule_workers.display_order')}, dependent: :destroy
  has_many :workers, -> {with_deleted}, through: :schedule_workers

  has_one :minute, dependent: :destroy

  scope :usual, -> {
                  where(worked_at: (Time.zone.today - DISPLAY_DAYS.days)..)
                    .includes(:work_type, :work_kind, schedule_workers: [worker: :home])
                    .order(worked_at: :ASC, id: :ASC)
                }

  scope :by_worker, ->(worker) {where([<<SQL.squish, worker.id])}
      EXISTS (SELECT * FROM schedule_workers
            WHERE schedule_workers.schedule_id = schedules.id AND schedule_workers.worker_id = ?)
SQL

  scope :for_minute, -> {
    where(["(worked_at BETWEEN (current_timestamp + '-1 year') AND current_timestamp) AND (minutes_flag = ?)", true])
    .order(worked_at: :ASC, id: :ASC)
  }

  scope :for_calendar, ->(term, work_kinds) {
    group(:worked_at, :work_kind_id)
      .select("min(schedules.id) AS id, schedules.worked_at, schedules.work_kind_id")
      .joins("INNER JOIN systems ON systems.term = #{term}")
      .includes(:work_kind, :minute)
      .where(work_kind_id: work_kinds, work_flag: false)
      .where("schedules.worked_at BETWEEN systems.start_date AND systems.end_date")
  }

  scope :for_training, ->(work) {
    where(worked_at: work.worked_at..)
    .where("work_flag = FALSE")
    .includes(:work_kind, :schedule_workers)
    .order(worked_at: :ASC, id: :ASC)
  }

  scope :linable, -> { where(line_flag: true) }

  scope :tomorrow, -> { where(worked_at: Date.tomorrow) }
  scope :today, -> { where(worked_at: Time.zone.today) }
  scope :am_only, -> {
    where("EXTRACT(HOUR FROM start_at) < 12")
  }
  scope :pm_only, -> {
    where("EXTRACT(HOUR FROM start_at) >= 12")
  }

  def regist_workers(params)
    workers = []
    params.each do |param|
      worker_id = param[:worker_id].to_i
      workers << worker_id
      display_order = param[:display_order].to_i
      schedule_worker = schedule_workers.find_by(worker_id: worker_id)
      if schedule_worker
        # display_orderが異なる場合のみupdateを実行
        schedule_worker.update(display_order: display_order) if schedule_worker.display_order != display_order
      else
        ScheduleWorker.create(schedule_id: id, worker_id: worker_id, display_order: display_order)
      end
    end
    
    # このスケジュールに属さないworker_idを持つschedule_workersを削除
    schedule_workers.where.not(worker_id: workers).destroy_all
  end
end
