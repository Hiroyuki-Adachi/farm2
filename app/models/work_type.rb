# == Schema Information
#
# Table name: work_types
#
#  id(作業分類マスタ)              :integer          not null, primary key
#  bg_color(背景色)                :string(8)
#  category_flag(カテゴリーフラグ) :boolean          default(FALSE)
#  deleted_at                      :datetime
#  display_order(表示順)           :integer          default(0), not null
#  genre(作業ジャンル)             :integer          not null
#  icon(アイコン)                  :binary
#  icon_name(アイコン名)           :string(40)
#  land_flag(土地利用)             :boolean          default(TRUE), not null
#  name(作業分類名称)              :string(10)       not null
#
# Indexes
#
#  index_work_types_on_deleted_at  (deleted_at)
#
class WorkType < ApplicationRecord
  acts_as_paranoid

  has_one :plan, class_name: "PlanWorkType", dependent: :destroy

  scope :categories, -> {where(category_flag: true).order(display_order: :ASC, id: :ASC)}
  scope :usual, -> {order(category_flag: :ASC, display_order: :ASC, id: :ASC)}
  scope :indexes, -> {where(category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :land, -> {where(land_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :select_category, -> (category) {where(category_flag: false, genre: category[:genre]).order(display_order: :ASC, id: :ASC)}

  def genre_id
    Rails.cache.fetch("genre_id_#{self[:genre]}", expires_in: 1.hour) do
      WorkType.with_deleted.find_by(genre: self[:genre], category_flag: true).id
    end
  end

  def genre_name
    Rails.cache.fetch("genre_name_#{self[:genre]}", expires_in: 1.hour) do
      WorkType.with_deleted.find_by(genre: self[:genre], category_flag: true).name
    end
  end

  def name_format
    genre_name + "(#{name})"
  end
end
