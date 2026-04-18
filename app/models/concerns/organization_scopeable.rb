module OrganizationScopeable
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    scope :by_organization, ->(organization) { where(organization_id: organization.id) }
  end
end
