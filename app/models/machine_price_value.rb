class MachinePriceValue < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  
  belongs_to :group, {class_name: "MachinePriceGroup"}
  belongs_to :adjust
  belongs_to :lease

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
end
