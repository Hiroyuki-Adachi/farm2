# == Schema Information
#
# Table name: schedules
#
#  id(作業予定)           :integer          not null, primary key
#  end_at(終了予定時刻)   :datetime         default(Thu, 01 Jan 1970 17:00:00.000000000 JST +09:00), not null
#  name(作業名称)         :string(40)       not null
#  start_at(開始予定時刻) :datetime         default(Thu, 01 Jan 1970 08:00:00.000000000 JST +09:00), not null
#  term(年度(期))         :integer          not null
#  work_flag(作業フラグ)  :boolean          default(TRUE), not null
#  worked_at(作業予定日)  :date             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  work_kind_id(作業種別) :integer          default(0), not null
#  work_type_id(作業分類) :integer
#
class Schedule < ApplicationRecord
  validates :worked_at, presence: true
  validates :name, length: {maximum: 40}, if: proc { |x| x.name.present?}
  validates :work_type_id, presence: true
  validates :work_kind_id, presence: true

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}

  has_many :schedule_workers, -> {order('schedule_workers.display_order')}, {dependent: :destroy}
  has_many :workers, -> {with_deleted}, {through: :schedule_workers}

  has_one :minute, {dependent: :destroy}

  scope :usual, -> {
      where(["worked_at >= current_date"])
        .includes(:work_type, :work_kind, schedule_workers: [worker: :home])
        .order(worked_at: :ASC, id: :ASC)
    }

  scope :by_worker, ->(worker) {where([<<SQL, worker.id])}
      EXISTS (SELECT * FROM schedule_workers
            WHERE schedule_workers.schedule_id = schedules.id AND schedule_workers.worker_id = ?)
SQL

  scope :for_minute, -> {where(["(worked_at BETWEEN (current_timestamp + '-1 year') AND current_timestamp) AND (work_flag = ?)", false]).order(worked_at: :ASC, id: :ASC)}

  scope :for_calendar, ->(term, work_kinds) {
    group(:worked_at, :work_kind_id)
      .select("min(schedules.id) AS id, schedules.worked_at, schedules.work_kind_id")
      .joins("INNER JOIN systems ON systems.term = #{term}")
      .includes(:work_kind, :minute)
      .where(work_kind_id: work_kinds, work_flag: false)
      .where("schedules.worked_at BETWEEN systems.start_date AND systems.end_date")
  }

  def regist_workers(params)
    workers = []
    params.each do |param|
      param = OpenStruct.new(param)
      workers << param.worker_id.to_i
      schedule_worker = schedule_workers.find_by(worker_id: param.worker_id)
      if schedule_worker
        schedule_worker.update(display_order: param.display_order) if schedule_worker.display_order != param.display_order.to_i
      else
        ScheduleWorker.create(schedule_id: id, worker_id: param.worker_id, display_order: param.display_order)
      end
    end
    schedule_workers.where.not(worker_id: workers).each(&:destroy)
  end
end
