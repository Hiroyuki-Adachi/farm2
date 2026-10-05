# == Schema Information
#
# Table name: sorimachi_accounts(ソリマチ勘定科目)
#
#  id                           :bigint           not null, primary key
#  code(科目コード)             :integer          default(0), not null
#  name(名称)                   :string(10)       default(""), not null
#  term(年度(期))               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  organization_id(組織)        :bigint
#  total_cost_type_id(原価種別) :integer          default(0), not null
#
# Indexes
#
#  sorimachi_accounts_2nd  (organization_id,term,code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class SorimachiAccount < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  query_constraints :organization_id, :term, :code
  before_destroy :clear_journals

  # query_constraints から外部キーを推論させないよう明示する。
  belongs_to :organization, foreign_key: :organization_id, optional: true # rubocop:disable Rails/RedundantForeignKey
  belongs_to_active_hash :total_cost_type, optional: true

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  def self.import(term, organization_id)
    SorimachiAccount.for_organization(organization_id).where(term: term - 1).find_each do |sorimachi_account|
      next if SorimachiAccount.for_organization(organization_id).exists?(term: term, code: sorimachi_account.code)

      account = SorimachiAccount.new(sorimachi_account.attributes)
      account.term = term
      account.id = nil
      account.save!
    end
  end

  def self.to_h(term, organization)
    SorimachiAccount.for_organization(organization).where(term: term).order(:code).to_h { |a| [a.code, a.name] }
  end

  def sales?
    total_cost_type == TotalCostType::SALES
  end

  private

  def clear_journals
    SorimachiJournal.for_organization(organization_id).where(term: term)
      .where("code01 = ? OR code12 = ?", code, code).find_each(&:clear_flags)
  end
end
