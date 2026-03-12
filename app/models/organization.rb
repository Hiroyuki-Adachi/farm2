# == Schema Information
#
# Table name: organizations(組織(体系)マスタ)
#
#  id(組織(体系)マスタ)                      :integer          not null, primary key
#  chemical_group_count(薬剤グループ数)      :integer          default(1)
#  chemicals_count(作業日報の薬剤数)         :integer          default(4), not null
#  consignor_code(委託者コード)              :string(10)
#  consignor_name(委託者コード)              :string(40)
#  daily_worker(作業日報の作業者名付加情報)  :integer          default("no_print"), not null
#  lands_count(作業日報の土地数)             :integer          default(17), not null
#  location(位置)                            :point            default(#<struct ActiveRecord::Point x=35.0, y=135.0>), not null
#  machines_count(作業日報の機械数)          :integer          default(8), not null
#  name(組織名称)                            :string(20)       not null
#  term(現在の年度(期))                      :integer          default(0), not null
#  url(URL)                                  :string
#  workers_count(作業日報の作業者数)         :integer          default(12), not null
#  created_at                                :datetime
#  updated_at                                :datetime
#  broccoli_work_kind_id(ブロッコリ種別分類) :integer
#  broccoli_work_type_id(ブロッコリ作業分類) :integer
#  cleaning_id(清掃id)                       :integer
#  contract_work_type_id(受託作業分類)       :integer
#  harvesting_work_kind_id(稲刈作業種別)     :integer
#  maintenance_id(機械保守id)                :integer
#  rice_planting_id(田植作業種別)            :integer
#  straw_id(稲わらid)                        :integer
#  training_id(訓練id)                       :integer
#  whole_crop_work_kind_id(WCS収穫分類)      :integer
#

class Organization < ApplicationRecord
  enum :daily_worker, {no_print: 0, print_home: 1, print_section: 2}

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

  def get_system(date)
    System.get_system(date, self.id)
  end

  def get_term(date)
    get_system(date || Time.zone.today)&.term
  end
end
