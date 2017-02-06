# == Schema Information
#
# Table name: machine_price_details # 機械利用単価マスタ(明細)
#
#  id                      :integer          not null, primary key # 機械利用単価マスタ(明細)
#  machine_price_header_id :integer          not null              # 単価ヘッダ
#  lease_id                :integer          not null              # リース
#  work_kind_id            :integer          default(0), not null  # 作業種別
#  adjust_id               :integer                                # 単位
#  price                   :decimal(5, )     default(0), not null  # 単価
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class MachinePriceDetail < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :header, {class_name: :MachinePriceHeader}
  belongs_to :work_kind
  belongs_to :adjust
  belongs_to :lease

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
end
