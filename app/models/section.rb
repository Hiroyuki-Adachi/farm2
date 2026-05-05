# == Schema Information
#
# Table name: sections(班／町内マスタ)
#
#  id(班／町内マスタ)      :integer          not null, primary key
#  deleted_at              :datetime
#  display_order(表示順)   :integer          default(1), not null
#  name(班名称)            :string(40)       not null
#  work_flag(作業班フラグ) :boolean          default(TRUE), not null
#  created_at              :datetime
#  updated_at              :datetime
#  organization_id(組織)   :bigint           default(3), not null
#
# Indexes
#
#  index_sections_on_deleted_at       (deleted_at)
#  index_sections_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class Section < ApplicationRecord
  include Discard::Model

  self.discard_column = :deleted_at

  belongs_to :organization

  has_many :homes, -> { order("homes.display_order, homes.id") }, dependent: :restrict_with_error
  has_many :schedule_sections, dependent: :destroy
  has_many :schedules, through: :schedule_sections

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }
  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :list, -> { kept.order(display_order: :asc) }
  scope :usual_order, -> { kept.order(work_flag: :desc, display_order: :asc) }
  scope :usual, -> { kept.where(work_flag: true).usual_order }
end
