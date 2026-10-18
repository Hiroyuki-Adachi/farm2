# == Schema Information
#
# Table name: work_categories(作業カテゴリ)
#
#  id                         :bigint           not null, primary key
#  discarded_at(論理削除日時) :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(名称)                 :string(10)       default(""), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  organization_id(組織)      :bigint
#
# Indexes
#
#  index_work_categories_on_organization_id  (organization_id)
#  work_categories_2nd                       (organization_id,id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class WorkCategory < ApplicationRecord
  include Discard::Model

  belongs_to :organization, optional: true
  has_many :genres, class_name: "WorkGenre", dependent: :restrict_with_error

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual_order, -> { order(:display_order, :id) }
  scope :usual, -> { kept.usual_order }
  scope :for_index, -> { usual_order }

  def remove_by_policy!
    with_lock do
      if genres.kept.exists?
        errors.add(:base, "作業ジャンルが存在するため削除できません")
        raise ActiveRecord::RecordNotDestroyed, self
      end

      if genres.exists?
        discard!
        :discarded
      else
        destroy!
        :destroyed
      end
    end
  end
end
