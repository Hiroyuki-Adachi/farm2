# == Schema Information
#
# Table name: systems(システムマスタ)
#
#  id(システムマスタ)                   :integer          not null, primary key
#  adjust_price(基準額(調整のみ))       :decimal(4, )     default(0), not null
#  default_fee(初期値(管理料))          :decimal(6, )     default(15000), not null
#  default_price(初期値(工賃))          :decimal(5, )     default(1000), not null
#  dry_adjust_price(基準額(乾燥調整))   :decimal(4, )     default(0), not null
#  dry_price(基準額(乾燥のみ))          :decimal(4, )     default(0), not null
#  end_date(期末日)                     :date             not null
#  half_sum_flag(半端米集計フラグ)      :boolean          default(FALSE), not null
#  light_oil_price(軽油価格)            :decimal(4, )     default(0), not null
#  relative_price(縁故米加算額)         :decimal(5, )     default(0), not null
#  roll_price                           :decimal(4, 1)    default(0.0), not null
#  seedling_price(育苗費)               :decimal(4, )     default(0), not null
#  start_date(期首日)                   :date             not null
#  term(年度(期))                       :integer          not null
#  waste_adjust_price(くず米金額(調整)) :decimal(4, )     default(0), not null
#  waste_drying_price(くず米金額(乾燥)) :decimal(4, )     default(0), not null
#  waste_price(くず米金額)              :decimal(4, )     default(0), not null
#  created_at                           :datetime
#  updated_at                           :datetime
#  organization_id(組織)                :integer          default(0), not null
#  seedling_chemical_id(育苗土)         :integer          default(0)
#
# Indexes
#
#  index_systems_on_term_and_organization_id  (term,organization_id) UNIQUE
#

class System < ApplicationRecord
  validates :term,        presence: true
  validates :term, numericality: { only_integer: true, greater_than: 2000, less_than: 2100 }
  validate :validate_period_dates
  validate :validate_period_continuity
  validate :validate_period_order

  def self.get_system(date, organization_id)
    System.find_by("start_date <= ? AND end_date >= ? AND organization_id = ?", date, date, organization_id)
  end

  def self.min_date(organization_id)
    System.where(organization_id: organization_id).minimum(:start_date)
  end

  def self.max_date(organization_id)
    System.where(organization_id: organization_id).maximum(:end_date)
  end

  def self.init(organization_id, term)
    if term
      system = System.find_by(term: term, organization_id: organization_id)
      pre_system = System.find_by(term: term.to_i - 1, organization_id: organization_id)
      if pre_system && system.nil?
        system = System.new(pre_system.attributes.except("id", "created_at", "updated_at"))
        system.term = term
        system.start_date  = pre_system.start_date + 1.year
        system.end_date    = pre_system.end_date + 1.year
      end
    end
    system
  end

  def get_prev_terms(limit, term: nil)
    self.class.get_terms(organization_id, term || self.term, limit)
  end

  def self.get_terms(organization_id, start_term, limit)
    # Get terms up to and including start_term
    where(organization_id:, term: ..start_term).order(term: :desc).limit(limit).pluck(:term)
  end

  private

  def validate_period_dates
    return if start_date.blank? || end_date.blank?

    errors.add(:start_date, "は月初にしてください。") unless start_date.day == 1
    errors.add(:end_date, "は期首日以降にしてください。") if end_date < start_date
    errors.add(:end_date, "は月末にしてください。") unless end_date == end_date.end_of_month
  end

  def validate_period_continuity
    return if start_date.blank? || end_date.blank? || organization_id.blank? || term.blank?

    if previous_system && start_date != previous_system.end_date.next_day
      errors.add(:start_date, "は前期の期末日の翌日にしてください。")
    end

    if next_system_for_validation && next_system_for_validation.start_date != end_date.next_day
      errors.add(:end_date, "は次期の期首日の前日にしてください。")
    end
  end

  def validate_period_order
    return if start_date.blank? || end_date.blank? || organization_id.blank? || term.blank?

    same_organization = self.class.where(organization_id: organization_id).where.not(id: id)

    if same_organization.where("start_date <= ? AND end_date >= ?", end_date, start_date).exists?
      errors.add(:base, "期首日と期末日が他の期と重複しています。")
    end

    if same_organization.where("term < ? AND end_date >= ?", term, start_date).exists?
      errors.add(:start_date, "は前期以前の期間より後にしてください。")
    end

    if same_organization.where("term > ? AND start_date <= ?", term, end_date).exists?
      errors.add(:end_date, "は次期以降の期間より前にしてください。")
    end
  end

  def previous_system
    self.class
      .where(organization_id: organization_id)
      .where("term < ?", term)
      .order(term: :desc)
      .first
  end

  def next_system_for_validation
    self.class
      .where(organization_id: organization_id)
      .where("term > ?", term)
      .order(term: :asc)
      .first
  end

end
