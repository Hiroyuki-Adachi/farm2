# == Schema Information
#
# Table name: work_genres(作業ジャンル)
#
#  id                             :bigint           not null, primary key
#  discarded_at(論理削除日時)     :datetime
#  display_order(表示順)          :integer          default(0), not null
#  name(名称)                     :string(10)       default(""), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  work_category_id(作業カテゴリ) :bigint           not null
#
# Indexes
#
#  index_work_genres_on_work_category_id  (work_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_category_id => work_categories.id)
#
class WorkGenre < ApplicationRecord
  include Discard::Model

  belongs_to :category, class_name: "WorkCategory", foreign_key: "work_category_id"

  scope :usual, -> { kept.joins(:category).order("work_categories.display_order, work_genres.display_order, work_genres.id") }

  def combine_name
    "#{category.name} ＞ #{name}"
  end
end
