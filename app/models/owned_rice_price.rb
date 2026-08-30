# == Schema Information
#
# Table name: owned_rice_prices(保有米単価)
#
#  id                       :bigint           not null, primary key
#  display_order(表示順)    :integer          default(0), not null
#  name(品種名)             :string(10)       default(""), not null
#  owned_price(保有米価格)  :decimal(5, )     default(0), not null
#  short_name(品種名(略称)) :string(5)        default(""), not null
#  term(年度(期))           :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  organization_id(組織)    :bigint           not null
#  work_type_id(品種)       :integer          default(0), not null
#
# Indexes
#
#  index_owned_rice_prices_on_organization_id  (organization_id)
#  owned_rice_prices_2nd                       (organization_id,term,work_type_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class OwnedRicePrice < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :work_type

  has_many   :owned_rices, dependent: :destroy

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual, ->(term) { where(term: term).order(:display_order) }
end
