# == Schema Information
#
# Table name: machines # 機械マスタ
#
#  id                :integer          not null, primary key    # 機械マスタ
#  name              :string(40)       not null                 # 機械名称
#  display_order     :integer          not null                 # 表示順
#  validity_start_at :date                                      # 稼動開始日
#  validity_end_at   :date                                      # 稼動終了(予定)日
#  machine_type_id   :integer          default(0), not null     # 機械種別
#  home_id           :integer          default(0), not null     # 所有者
#  created_at        :datetime
#  updated_at        :datetime
#  deleted_at        :datetime
#  diesel_flag       :boolean          default(FALSE), not null # ディーゼル
#

class Machine < ApplicationRecord
  acts_as_paranoid

  has_many  :machine_results
  has_many  :work_results, through: :machine_results

  belongs_to :machine_type
  has_many :machine_kinds, through: :machine_type
  has_many :price_headers, {class_name: :MachinePriceHeader, dependent: :destroy}, -> {order("machine_price_headers.validated_at DESC")}

  belongs_to :owner, {class_name: :Home, foreign_key: :home_id}, -> {with_deleted}

  validates :validity_start_at, presence: true
  validates :validity_end_at, presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  scope :by_work, -> (work) { 
    includes(:machine_type, :machine_kinds)
      .where("(machine_kinds.work_kind_id = ? and validity_start_at <= ? and ? <= validity_end_at) OR (machines.id in (?))", work.work_kind_id, work.worked_at, work.worked_at, work.machine_results.pluck(:machine_id))
      .order("machine_types.display_order, machines.display_order")
  }
  scope :diesel, -> {where(diesel_flag: true)}

  scope :of_company, -> {where(home_id: Home.company)}
  scope :of_owners, ->(work) {where(home_id: work.workers.pluck(:home_id).uniq)}
  scope :of_no_owners, ->(work) {where.not(home_id: work.workers.pluck(:home_id).uniq)}
  scope :between_term, ->(system) {
    where(["validity_start_at <= ? AND validity_end_at >= ?", system.start_date, system.end_date])
  }

  scope :by_results, -> (results) {
    joins(:machine_results)
      .where('machine_results.work_result_id in (?)', results.ids)
      .order('machines.display_order')
      .uniq
  }

  scope :usual, -> {
    includes(:machine_type)
      .order("machine_types.display_order, machines.display_order, machines.id")
  }

  def company?
    owner.company_flag?
  end

  def price_details(work)
    header = price_headers.where("validated_at <= ?", work.worked_at).order(validated_at: :DESC).first
    return header.details if header
    return machine_type ? machine_type.price_details(work) : nil
  end

  def leasable?(worked_at)
    return false if company?
    header = price_headers.where("validated_at <= ?", worked_at).order(validated_at: :DESC).first
    return header.details.where(lease_id: Lease::LEASE).exists? if header
    header = machine_type.price_headers.where("validated_at <= ?", worked_at).order(validated_at: :DESC).first
    return header.details.where(lease_id: Lease::LEASE).exists? if header
    return false
  end

  def hours(results)
    MachineResult.where("machine_id = ? and work_result_id in (?)", id, results.ids).sum(:hours)
  end

  def owner_name
    owner ? owner.name : ""
  end

  def type_name
    machine_type ? machine_type.name : ""
  end

  def usual_name
    company? ? "#{type_name}(#{name})" : "#{type_name}(#{owner_name})"
  end
end
