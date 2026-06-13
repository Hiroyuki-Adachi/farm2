# == Schema Information
#
# Table name: land_term_marks(土地年度別記号)
#
#  id             :bigint           not null, primary key
#  mark(記号)     :string(10)       not null
#  term(年度(期)) :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  land_id(土地)  :bigint           not null
#
# Indexes
#
#  index_land_term_marks_on_land_id_and_term  (land_id,term) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (land_id => lands.id)
#

class LandTermMark < ApplicationRecord
  belongs_to :land

  scope :by_term, ->(term) { where(term: term) }
  scope :for_organization, ->(organization) { joins(:land).merge(Land.for_organization(organization)) }
  scope :usual, -> { includes(land: [:owner, :manager, :owner_holder, :manager_holder]).order(:mark) }

  validates :term, presence: true, numericality: { only_integer: true }
  validates :mark, presence: true, length: { maximum: 10 }
  validates :land_id, uniqueness: { scope: :term }
end
