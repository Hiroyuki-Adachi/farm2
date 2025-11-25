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
#  seedling_price(育苗費)               :decimal(4, )     default(0), not null
#  start_date(期首日)                   :date             not null
#  target_from(開始年月)                :date
#  target_to(終了年月)                  :date
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
  validates :target_from, presence: true
  validates :target_to,   presence: true

  after_save :cache_clear

  validates :term, numericality: {only_integer: true, greater_than: 2000, less_than: 2100}

  def self.get_system(date, organization_id)
    System.find_by("start_date <= ? AND end_date >= ? AND organization_id = ?", date, date, organization_id)
  end

  def self.min_date(organization_id)
    System.where(organization_id: organization_id).minimum(:start_date)
  end

  def self.max_date(organization_id)
    System.where(organization_id: organization_id).maximum(:end_date)
  end

  def self.init(organization_id, term, target_from = nil, target_to = nil)
    if term
      system = System.find_by(term: term, organization_id: organization_id)
      pre_system = System.find_by(term: term.to_i - 1, organization_id: organization_id)
      if pre_system && system.nil?
        system = System.new(pre_system.attributes.except("id", "created_at", "updated_at"))
        system.term = term
        system.target_from = pre_system.start_date + 1.year
        system.target_to   = pre_system.end_date + 1.year
        system.start_date  = pre_system.start_date + 1.year
        system.end_date    = pre_system.end_date + 1.year
      end
    else
      system = System.find_by(term: term)
      if system
        system.target_from = Date.strptime(target_from, "%Y-%m")
        system.target_to   = Date.strptime(target_to, "%Y-%m")
      end
    end
    return system
  end

  def get_prev_terms(limit, term: nil)
    self.class.get_terms(self.organization_id, term || self.term, limit)
  end

  def self.get_terms(organization_id, start_term, limit)
    self.where(organization_id:, term: ..start_term).order(start_date: :desc).limit(limit).pluck(:term)
  end

  private

  def cache_clear
    Rails.cache.clear
  end
end
