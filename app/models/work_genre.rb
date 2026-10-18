# == Schema Information
#
# Table name: work_genres(作業ジャンル)
#
#  id                             :bigint           not null, primary key
#  discarded_at(論理削除日時)     :datetime
#  display_order(表示順)          :integer          default(0), not null
#  graph_color(グラフ色)          :string(8)        default("#ffffff"), not null
#  name(名称)                     :string(10)       default(""), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  organization_id(組織)          :bigint
#  work_category_id(作業カテゴリ) :bigint           not null
#
# Indexes
#
#  index_work_genres_on_work_category_id  (work_category_id)
#  work_genres_2nd                        (organization_id,id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...                          (organization_id => organizations.id)
#  fk_rails_...                          (work_category_id => work_categories.id)
#  fk_work_genres_organization_category  ([organization_id, work_category_id] => work_categories[organization_id, id])
#
class WorkGenre < ApplicationRecord
  include Discard::Model

  belongs_to :organization, optional: true
  belongs_to :category, class_name: "WorkCategory", foreign_key: "work_category_id"
  has_many :work_types, class_name: "WorkType", dependent: :restrict_with_error

  before_validation :set_organization_from_category
  validate :organization_matches_category

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual_order, -> { joins(:category).order("work_categories.display_order, work_genres.display_order, work_genres.id") }
  scope :usual, -> { kept.usual_order }
  scope :for_index, -> { usual_order }

  def combined_name
    category.name == name ? name : "#{category.name}＞#{name}"
  end

  def remove_by_policy!
    with_lock do
      if work_types.kept.exists?
        errors.add(:base, "作業分類が存在するため削除できません")
        raise ActiveRecord::RecordNotDestroyed, self
      end

      if work_types.exists?
        discard!
        :discarded
      else
        destroy!
        :destroyed
      end
    end
  end

  private

  def set_organization_from_category
    self.organization_id ||= category&.organization_id
  end

  def organization_matches_category
    return if category.nil? || organization_id == category.organization_id

    errors.add(:work_category_id, "は同じ組織の作業カテゴリを選択してください")
  end
end
