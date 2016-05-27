# == Schema Information
#
# Table name: machine_price_details
#
#  id                      :integer          not null, primary key
#  machine_price_header_id :integer          not null
#  lease_id                :integer          not null
#  work_kind_id            :integer          default(0), not null
#  adjust_id               :integer
#  price                   :decimal(5, )     default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class MachinePriceDetail < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :header, {class_name: :MachinePriceHeader}
  belongs_to :work_kind
  belongs_to :adjust
  belongs_to :lease

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
end
