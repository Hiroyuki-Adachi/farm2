require 'date'
require 'securerandom'
# == Schema Information
#
# Table name: work_results # 作業結果データ
#
#  id            :integer          not null, primary key  # 作業結果データ
#  work_id       :integer                                 # 作業
#  worker_id     :integer                                 # 作業者
#  hours         :decimal(5, 1)    default(0.0), not null # 作業時間
#  display_order :integer          default(0), not null   # 表示順
#  fixed_hours   :decimal(5, 1)                           # 確定作業時間
#  fixed_price   :decimal(5, )                            # 確定作業単価
#  fixed_amount  :decimal(7, )                            # 確定作業日当
#  created_at    :datetime
#  updated_at    :datetime
#  uuid          :string(36)                              # UUID(カレンダー用)
#

class WorkResult < ApplicationRecord
  belongs_to :work
  belongs_to :worker, -> {with_deleted}
  has_one    :home, -> {with_deleted}, {through: :worker}
  has_one    :work_type, -> {with_deleted}, {through: :work}
  has_one    :work_kind, -> {with_deleted}, {through: :work}

  before_create :set_uuid

  has_many  :machine_results, {dependent: :destroy}
  has_many  :machines, {through: :machine_results}

  validates :hours, presence: true
  validates :hours, numericality: true, :if => proc{|x| x.hours.present?}

  scope :by_worker_and_work, ->(worker, work) {where(worker_id: worker, work_id: work)}

  scope :by_home, ->(term){
      joins(:work).eager_load(:work)
     .joins(:worker).eager_load(:worker)
     .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
     .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
     .joins("INNER JOIN homes ON homes.id = workers.home_id").preload(:home)
     .joins("INNER JOIN systems ON systems.term = works.term")
     .joins("INNER JOIN sections ON sections.id = homes.section_id")
     .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
     .where("systems.term = ?", term)
     .order("sections.display_order, homes.display_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  scope :by_home_for_fix, ->(term, fixed_at){
      joins(:work).eager_load(:work)
     .joins(:worker).eager_load(:worker)
     .joins(:work_type).eager_load(:work_type)
     .joins("INNER JOIN homes ON homes.id = workers.home_id").preload(:home)
     .joins("INNER JOIN sections ON sections.id = homes.section_id")
     .where("works.term = ? AND works.fixed_at = ?", term, fixed_at)
     .order("sections.display_order, homes.display_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  scope :for_personal, ->(worker, worked_at) {
     joins(:work).eager_load(:work)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
      .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
      .where("works.worked_at >= ?", worked_at)
      .where(worker_id: worker)
      .order("works.worked_at, work_results.id")
  }

  scope :for_menu, ->(worker, term) {
    joins(:work).eager_load(:work)
     .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
     .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
     .where("works.term = ?", term)
     .where(worker_id: worker)
     .order("works.worked_at DESC, work_results.id")
  }

  def price
    (work.fixed_at ? fixed_price : work.work_kind.term_price(work.term)) || 0
  end

  def amount
    (work.fixed_at ? fixed_amount : hours * price) || 0
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def worker_name
    worker.name
  end
end
