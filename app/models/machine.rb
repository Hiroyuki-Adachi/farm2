# == Schema Information
#
# Table name: machines
#
#  id                :integer          not null, primary key
#  name              :string(40)       not null
#  display_order     :integer          not null
#  validity_start_at :date
#  validity_end_at   :date
#  machine_type_id   :integer          default(0), not null
#  home_id           :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#  deleted_at        :datetime
#

class Machine < ActiveRecord::Base
  acts_as_paranoid

  has_many  :machine_results
  has_many  :work_results, through: :machine_results, dependent: :restrict_with_exception

  belongs_to :machine_type
  has_many :machine_kinds, through: :machine_type
  has_many :price_headers, {class_name: :MachinePriceHeader, dependent: :destroy}, -> {order("machine_price_headers.validated_at DESC")}

  belongs_to :owner, {class_name: :Home, foreign_key: :home_id}, -> {with_deleted}

  validates :validity_start_at, presence: true
  validates :validity_end_at, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  scope :by_work, -> (work) { 
     includes(:machine_type, :machine_kinds)
    .where("(machine_kinds.work_kind_id = ? and validity_start_at <= ? and ? <= validity_end_at) OR (machines.id in (?))", work.work_kind_id, work.worked_at, work.worked_at, work.machine_results.pluck(:machine_id))
    .order("machine_types.display_order, machines.display_order")
  }
  
  scope :of_company, ->{where(home_id: Home.where(company_flag: true))}
  scope :of_owners, ->(work){where(home_id: work.workers.pluck(:home_id).uniq)}
  scope :of_no_owners, ->(work){where.not(home_id: work.workers.pluck(:home_id).uniq)}

  scope :by_results, -> (results) {
    joins(:machine_results)
    .where('machine_results.work_result_id in (?)', results.ids)
    .order('machines.display_order').uniq
  }
  
  scope :usual, -> {includes(:machine_type).order("machine_types.display_order, machines.display_order, machines.id")}

  def operators(work)
    operators = []
    work.work_results.each do |result|
      operators << result.worker.home.name if self.work_results.include?(result)
    end

    return operators.join(',')
  end
  
  def company?
    return self.owner.company_flag?
  end
  
  def price_details(work)
    headers = price_headers.where("validated_at <= ?", work.worked_at).order("validated_at")
    return headers.exists? ? headers.first.details : machine_type.price_details(work)
  end
  
  def leasable?(worked_at)
    return false if self.company?
    headers = self.price_headers.where("validated_at <= ?", worked_at)
    return headers.order(validated_at: :DESC).first.details.where(lease_id: Lease::LEASE).exists? if headers.exists? 
    headers = self.machine_type.price_headers.where("validated_at <= ?", worked_at)
    return headers.order(validated_at: :DESC).first.details.where(lease_id: Lease::LEASE).exists? if headers.exists?
    return false
  end
  
  def hours(results)
    return MachineResult.where("machine_id = ? and work_result_id in (?)", self.id, results.ids).sum(:hours)
  end
  
  def owner_name
    return self.owner ? self.owner.name : ""
  end
  
  def type_name
    return self.machine_type ? self.machine_type.name : ""
  end
  
  def usual_name
    return self.company? ? "#{type_name}(#{self.name})" : "#{type_name}(#{owner_name})"
  end
end
