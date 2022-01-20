# == Schema Information
#
# Table name: machine_price_details
#
#  id                      :integer          not null, primary key
#  machine_price_header_id :integer          not null
#  lease_id                :integer          not null
#  work_kind_id            :integer          default("0"), not null
#  adjust_id               :integer
#  price                   :decimal(5, )     default("0"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  machine_price_details_2nd_key  (machine_price_header_id,lease_id,work_kind_id) UNIQUE
#

class MachinePriceDetail < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :header, class_name: :MachinePriceHeader
  belongs_to :work_kind
  belongs_to_active_hash :lease
  belongs_to_active_hash :adjust

  validates :price, presence: true
  validates :price, numericality: true, if: proc { |x| x.price.present?}
end
