# == Schema Information
#
# Table name: chemical_terms(薬剤年度別利用マスタ)
#
#  id                    :integer          not null, primary key
#  price(価格)           :decimal(6, )     default(0), not null
#  term(年度(期))        :integer          not null
#  chemical_id(薬剤)     :integer          not null
#  organization_id(組織) :bigint           not null
#
# Indexes
#
#  idx_on_organization_id_chemical_id_term_38ad97d24a  (organization_id,chemical_id,term) UNIQUE
#  index_chemical_terms_on_organization_id             (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class ChemicalTerm < ApplicationRecord
  belongs_to :organization
  belongs_to :chemical, -> { with_deleted }
  has_many :chemical_work_types, dependent: :destroy
  has_many :work_types, through: :chemical_work_types

  validate :chemical_same_organization

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :usual, lambda { |term, organization = nil|
    joins(chemical: :chemical_type).includes(:chemical)
      .where(term: term)
      .then { |base| organization ? base.for_organization(organization) : base }
      .order(Arel.sql(<<SQL.squish))
        chemical_types.display_order, chemical_types.id, chemicals.phonetic, chemicals.display_order, chemicals.id
SQL
  }

  scope :by_type, lambda { |term, chemical_type_id, organization = nil|
    joins(:chemical)
      .where(term: term)
      .then { |base| organization ? base.for_organization(organization) : base }
      .where(chemicals: { chemical_type_id: chemical_type_id })
      .order("chemicals.phonetic, chemicals.display_order, chemicals.id")
      .select("chemicals.*, chemical_terms.id AS chemical_term_id")
  }

  scope :land, -> { joins(:chemical).where(<<SQL.squish) }
  EXISTS (SELECT * FROM chemical_kinds WHERE chemical_kinds.chemical_type_id = chemicals.chemical_type_id)
SQL

  def self.regist_price(params, organization = nil)
    params.each do |param|
      base = organization ? for_organization(organization) : all
      base.find(param[:id]).update(price: param[:price] || 0)
    end
  end

  delegate :name, to: :chemical, prefix: true

  def self.create_for_plans(params, term, organization)
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    ChemicalTerm.for_organization(organization_id).where(term: term).destroy_all
    params[:chemicals].each do |chemical_id|
      ChemicalTerm.create(term: term, chemical_id: chemical_id, organization_id: organization_id)
    end
  end

  def self.annual_update(old_term, new_term, organization)
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    ChemicalTerm.for_organization(organization_id).where(term: old_term).find_each do |chemical_term|
      unless ChemicalTerm.exists?(term: new_term, chemical_id: chemical_term.chemical_id, organization_id: organization_id)
        ChemicalTerm.create(
          chemical_id: chemical_term.chemical_id,
          organization_id: organization_id,
          term: new_term,
          price: chemical_term.price
        )
      end
    end
  end

  private

  def chemical_same_organization
    return if organization_id.blank? || chemical.blank? || chemical.organization_id == organization_id

    errors.add(:chemical_id, :invalid)
  end
end
