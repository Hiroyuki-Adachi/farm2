# == Schema Information
#
# Table name: schedules # 作業予定
#
#  id           :integer          not null, primary key # 作業予定
#  term         :integer          not null              # 年度(期)
#  worked_at    :date             not null              # 作業予定日
#  work_type_id :integer                                # 作業分類
#  work_kind_id :integer          default(0), not null  # 作業種別
#  name         :string(40)       not null              # 作業名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Schedule < ActiveRecord::Base
  validates :worked_at, presence: true
  validates :name, length: { maximum: 40 }, if: proc { |x| x.name.present? }
  validates :work_type_id, presence: true
  validates :work_kind_id, presence: true

  belongs_to :work_type, -> { with_deleted }
  belongs_to :work_kind, -> { with_deleted }

  has_many :schedule_workers, -> { order('schedule_workers.display_order') }, { dependent: :destroy }
  has_many :workers, { through: :schedule_workers }, -> { with_deleted }

  scope :usual, ->(term) { where(term: term).includes(:work_type, :work_kind).order(worked_at: :ASC, id: :ASC)}
  scope :by_worker, ->(worker) {
    where(["EXISTS (SELECT * FROM schedule_workers WHERE schedule_workers.schedule_id = schedules.id AND schedule_workers.worker_id = ?)", worker.id])
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
