class MachinePriceDetail < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :header, {class_name: :MachinePriceHeader}
  belongs_to :work_kind
  belongs_to :adjust
  belongs_to :lease

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
end
