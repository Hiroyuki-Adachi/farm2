# == Schema Information
#
# Table name: systems
#
#  id                   :integer          not null, primary key
#  term                 :integer          not null
#  target_from          :date
#  target_to            :date
#  created_at           :datetime
#  updated_at           :datetime
#  start_date           :date             not null
#  end_date             :date             not null
#  organization_id      :integer          default("0"), not null
#  default_price        :decimal(5, )     default("1000"), not null
#  default_fee          :decimal(6, )     default("15000"), not null
#  light_oil_price      :decimal(4, )     default("0"), not null
#  seedling_price       :decimal(4, )     default("0"), not null
#  seedling_chemical_id :integer          default("0")
#  dry_price            :decimal(4, )     default("0"), not null
#  adjust_price         :decimal(4, )     default("0"), not null
#  dry_adjust_price     :decimal(4, )     default("0"), not null
#  half_sum_flag        :boolean          default("false"), not null
#  relative_price       :decimal(5, )     default("0"), not null
#  waste_price          :decimal(4, )     default("0.0"), not null
#
# Indexes
#
#  index_systems_on_term                      (term) UNIQUE
#  index_systems_on_term_and_organization_id  (term,organization_id) UNIQUE
#

class System < ApplicationRecord
  validates :term,        presence: true
  validates :target_from, presence: true
  validates :target_to,   presence: true

  validates :term, numericality: {only_integer: true, greater_than: 2000, less_than: 2100}

  def self.get_system(date, organization_id)
    System.find_by("start_date <= ? AND end_date >= ? AND organization_id = ?", date, date, organization_id)
  end
end
