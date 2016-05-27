# == Schema Information
#
# Table name: chemicals
#
#  id               :integer          not null, primary key
#  name             :string(20)       not null
#  display_order    :integer          default(0), not null
#  chemical_type_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  deleted_at       :datetime
#

class Chemical < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :chemical_type
  has_many :chemical_terms

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  scope :usual, -> {includes(:chemical_type, :chemical_terms).where("chemical_terms.term = ?", System.first.term).order("chemical_types.display_order, chemicals.display_order, chemicals.id")}
  scope :list, ->{includes(:chemical_type).order("chemical_types.display_order, chemicals.display_order, chemicals.id")}
end
