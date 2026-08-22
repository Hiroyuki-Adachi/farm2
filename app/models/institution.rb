# == Schema Information
#
# Table name: institutions(施設マスタ)
#
#  id                       :bigint           not null, primary key
#  display_order(表示順)    :integer          not null
#  end_term(稼動終了年度)   :integer          default(9999), not null
#  location(位置)           :point
#  name(施設名称)           :string(40)       not null
#  start_term(稼動開始年度) :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  organization_id(組織)    :bigint
#
# Indexes
#
#  index_institutions_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Institution < ApplicationRecord
  belongs_to :organization, optional: true

  has_many :cleaning_institutions, dependent: :destroy

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual, -> { order(display_order: :ASC, id: :ASC) }
  scope :by_term, ->(term) { where("? BETWEEN start_term AND end_term", term) }

  def enable?(term)
    start_term <= term && end_term >= term
  end
end
