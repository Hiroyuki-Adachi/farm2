# == Schema Information
#
# Table name: organizations
#
#  id                      :integer          not null, primary key
#  name                    :string(20)       not null
#  workers_count           :integer          default("12"), not null
#  lands_count             :integer          default("17"), not null
#  machines_count          :integer          default("8"), not null
#  chemicals_count         :integer          default("4"), not null
#  daily_worker            :integer          default("0"), not null
#  consignor_code          :string(10)
#  consignor_name          :string(40)
#  bank_code               :string(4)        default("0000"), not null
#  branch_code             :string(3)        default("000"), not null
#  account_type_id         :integer          default("0"), not null
#  account_number          :string(7)        default("0000000"), not null
#  term                    :integer          default("0"), not null
#  created_at              :datetime
#  updated_at              :datetime
#  url                     :string
#  broccoli_work_type_id   :integer
#  broccoli_work_kind_id   :integer
#  chemical_group_count    :integer          default("1")
#  rice_planting_id        :integer
#  whole_crop_work_kind_id :integer
#  contract_work_type_id   :integer
#  harvesting_work_kind_id :integer
#  location                :point            default("(35,135)"), not null
#

class Organization < ApplicationRecord
  enum daily_worker: {no_print: 0, print_home: 1, print_section: 2}

  after_save :save_term

  validates :name, presence: true
  validates :workers_count, presence: true
  validates :lands_count, presence: true
  validates :machines_count, presence: true
  validates :chemicals_count, presence: true
  validates :daily_worker, presence: true

  validates :name, length: {maximum: 20}, if: proc { |x| x.name.present?}
  validates :url, length: {maximum: 255}, if: proc { |x| x.name.present?}

  belongs_to :broccoli_work_type, class_name: "WorkType"
  belongs_to :broccoli_work_kind, class_name: "WorkKind"
  belongs_to :rice_planting, class_name: "WorkKind"
  belongs_to :whole_crop, class_name: "WorkKind"
  belongs_to :contract, class_name: "WorkType"
  belongs_to :harvesting, class_name: "WorkKind"

  def self.term
    Rails.cache.fetch(:organization_term, expires_in: 1.hour) do
      Organization.first.term
    end
  end

  def save_term
    Rails.cache.write(:organization_term, term, expires_in: 1.hour)
  end
end
