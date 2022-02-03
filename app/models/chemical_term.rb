# == Schema Information
#
# Table name: chemical_terms
#
#  chemical_id :integer          not null
#  term        :integer          not null
#  id          :integer          not null, primary key
#  price       :decimal(6, )     default("0"), not null
#
# Indexes
#
#  index_chemical_terms_on_chemical_id_and_term  (chemical_id,term) UNIQUE
#

class ChemicalTerm < ApplicationRecord
  belongs_to :chemical, -> {with_deleted}
  has_many :chemical_work_types, dependent: :destroy
  
  scope :usual, -> (term) {
    joins(chemical: :chemical_type)
      .where(term: term)
      .order(Arel.sql(<<SQL))
        chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id
SQL
  }

  scope :by_type, -> (term, chemical_type_id) {
    joins(:chemical)
      .where(term: term)
      .where("chemicals.chemical_type_id = ?", chemical_type_id)
      .order("chemicals.phonetic, chemicals.display_order, chemicals.id")
      .select("chemicals.*, chemical_terms.id AS chemical_term_id")
  }

  scope :land, ->{joins(:chemical).where(<<SQL)}
  EXISTS (SELECT * FROM chemical_kinds WHERE chemical_kinds.chemical_type_id = chemicals.chemical_type_id)
SQL

  def self.regist_price(params)
    params.each do |param|
      ChemicalTerm.find(param[:id]).update(price: param[:price])
    end
  end

  def chemical_name
    chemical.name
  end

  def self.create_for_plans(params, term)
    ChemicalTerm.destroy_all
    params[:chemicals].each do |chemical_id|
      ChemicalTerm.create(term: term, chemical_id: chemical_id)
    end
  end

  def self.annual_update(old_term, new_term)
    ChemicalTerm.where(term: old_term).each do |chemical_term|
      unless ChemicalTerm.where(term: new_term, chemical_id: chemical_term.chemical_id).exists?
        ChemicalTerm.create(
          chemical_id: chemical_term.chemical_id,
          term: new_term,
          price: chemical_term.price
        )
      end
    end
  end
end
