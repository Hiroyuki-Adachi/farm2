# == Schema Information
#
# Table name: machine_price_details
#
#  id(機械利用単価マスタ(明細))        :integer          not null, primary key
#  price(単価)                         :decimal(5, )     default(0), not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  adjust_id(単位)                     :integer
#  lease_id(リース)                    :integer          not null
#  machine_price_header_id(単価ヘッダ) :integer          not null
#  work_kind_id(作業種別)              :integer          default(0), not null
#
# Indexes
#
#  machine_price_details_2nd_key  (machine_price_header_id,lease_id,work_kind_id) UNIQUE
#
class MachinePriceDetail < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :header, class_name: :MachinePriceHeader
  belongs_to :work_kind
  belongs_to :adjust
  belongs_to :lease

  validates :price, presence: true
  validates :price, numericality: true, if: proc { |x| x.price.present?}
end
