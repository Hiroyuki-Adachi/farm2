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
#

class WorkResult < ActiveRecord::Base
  belongs_to :work
  belongs_to :worker, -> {with_deleted}
  has_one    :home, {through: :worker}, -> {with_deleted}
  has_one    :work_type, {through: :work}, -> {with_deleted}

  has_many  :machine_results, {dependent: :destroy}
  has_many  :machines,  {through: :machine_results}

  validates :hours, presence: true
  validates :hours, numericality: true, :if => Proc.new{|x| x.hours.present?}

  scope :by_home, ->(term){
      joins(:work).eager_load(:work)
     .joins(:worker).eager_load(:worker)
     .joins(:work_type).eager_load(:work_type)
     .joins("INNER JOIN homes ON homes.id = workers.home_id").preload(:home)
     .joins("INNER JOIN systems ON systems.term = works.term")
     .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
     .where("systems.term = ?", term)
     .order("homes.display_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  scope :by_home_for_fix, ->(term, fixed_at){
      joins(:work).eager_load(:work)
     .joins(:worker).eager_load(:worker)
     .joins(:work_type).eager_load(:work_type)
     .joins("INNER JOIN homes ON homes.id = workers.home_id").preload(:home)
     .where("works.term = ? AND works.fixed_at = ?", term, fixed_at)
     .order("homes.display_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  def price
    (work.fixed_at ? self.fixed_price : work.work_kind.term_price(work.term)) || 0
  end

  def amount
    (work.fixed_at ? self.fixed_amount : hours * work.work_kind.term_price(work.term)) || 0
  end
end
