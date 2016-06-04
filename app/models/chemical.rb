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

  after_save :save_term

  belongs_to :chemical_type
  has_many :chemical_terms, {dependent: :delete_all}

  validates :name,          presence: true
  validates :display_order, presence: true
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}
  
  attr_accessor :term

  scope :usual, -> (term, work){
     joins(:chemical_type, :chemical_terms)
    .where("(chemical_terms.term = ? AND chemicals.chemical_type_id IN (?)) OR chemicals.id IN (?)", term, work.work_kind.chemical_kinds.pluck(:chemical_type_id), work.chemicals.pluck(:chemical_id))
    .order("chemical_types.display_order, chemicals.display_order, chemicals.id")
  }
  scope :list, ->{includes(:chemical_type).order("chemical_types.display_order, chemicals.display_order, chemicals.id")}
  
  def this_term_flag
    return self.chemical_terms.where(term: @term).exists?
  end
  
  def this_term_flag=(val)
    @this_term_flag = val
  end
  
  private
  def save_term
    @term = Organization.first.term unless @term
    if @this_term_flag
      ChemicalTerm.create(term: @term, chemical_id: self.id) unless self.chemical_terms.where(term: @term).exists?
    else
      self.chemical_terms.where(term: @term).delete_all
    end
  end
end
