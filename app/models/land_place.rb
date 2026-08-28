# == Schema Information
#
# Table name: land_places(場所マスタ)
#
#  id(場所マスタ)        :integer          not null, primary key
#  deleted_at            :datetime
#  display_order(表示順) :integer
#  name(場所名称)        :string(40)       not null
#  remarks(備考)         :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  organization_id(組織) :bigint
#
# Indexes
#
#  index_land_places_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class LandPlace < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at

  belongs_to :organization, optional: true

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual, -> { kept.order(display_order: :asc, id: :asc) }

  has_many :lands, dependent: :restrict_with_error
end
