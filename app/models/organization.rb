# == Schema Information
#
# Table name: organizations # 組織(体系)マスタ
#
#  id              :integer          not null, primary key        # 組織(体系)マスタ
#  name            :string(20)       not null                     # 組織名称
#  workers_count   :integer          default(12), not null        # 作業日報の作業者数
#  lands_count     :integer          default(17), not null        # 作業日報の土地数
#  machines_count  :integer          default(8), not null         # 作業日報の機械数
#  chemicals_count :integer          default(4), not null         # 作業日報の薬剤数
#  daily_worker    :integer          default(0), not null         # 作業日報の作業者名付加情報
#  consignor_code  :string(10)                                    # 委託者コード
#  consignor_name  :string(40)                                    # 委託者コード
#  bank_code       :string(4)        default("0000"), not null    # 口座の金融機関コード
#  branch_code     :string(3)        default("000"), not null     # 口座の支店コード
#  account_type_id :integer          default(0), not null         # 口座種別
#  account_number  :string(7)        default("0000000"), not null # 口座番号
#  term            :integer          default(0), not null         # 現在の年度(期)
#  created_at      :datetime
#  updated_at      :datetime
#

class Organization < ApplicationRecord
  enum daily_worker: { no_print: 0, print_home: 1, print_section: 2 }

  after_save :save_term

  validates :name, presence: true
  validates :workers_count, presence: true
  validates :lands_count, presence: true
  validates :machines_count, presence: true
  validates :chemicals_count, presence: true
  validates :daily_worker, presence: true

  validates :name, length: { maximum: 20 }, if: proc { |x| x.name.present? }

  def self.term
    Rails.cache.fetch(:organization_term, expires_in: 1.hour) do
      Organization.first.term
    end
  end

  def save_term
    Rails.cache.write(:organization_term, term, expires_in: 1.hour)
  end
end
