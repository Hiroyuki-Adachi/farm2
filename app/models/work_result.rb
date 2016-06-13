# == Schema Information
#
# Table name: work_results
#
#  id            :integer          not null, primary key
#  work_id       :integer
#  worker_id     :integer
#  hours         :decimal(3, 1)    default(0.0), not null
#  display_order :integer          default(0), not null
#  fixed_hours   :decimal(3, 1)
#  fixed_price   :decimal(4, )
#  fixed_amount  :decimal(6, )
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
     .where("systems.target_from <= works.worked_at and works.worked_at <= systems.target_to")
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

  def price(term)
    (work.fixed_at ? self.fixed_price : work.work_kind.term_price(term)) || 0
  end

  def amount(term)
    (work.fixed_at ? self.fixed_amount : hours * work.work_kind.term_price(term)) || 0
  end
end
