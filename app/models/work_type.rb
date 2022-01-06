# == Schema Information
#
# Table name: work_types
#
#  id(作業分類マスタ)              :integer          not null, primary key
#  bg_color(背景色)                :string(8)
#  category_flag(カテゴリーフラグ) :boolean          default(FALSE)
#  cost_flag(原価フラグ)           :boolean          default(FALSE), not null
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
  before_save :update_cost_flag

  has_one :plan, class_name: "PlanWorkType", dependent: :destroy

  scope :categories, -> {where(category_flag: true).order(display_order: :ASC, id: :ASC)}
  scope :usual, -> {where(work_flag: true).order(category_flag: :ASC, display_order: :ASC, id: :ASC)}
  scope :indexes, -> {where(category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :land, -> {where(land_flag: true, work_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :cost, -> {where(cost_flag: true, work_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :select_category, -> (category) {where(category_flag: false, work_flag: true, genre: category[:genre]).order(display_order: :ASC, id: :ASC)}

  def genre_id
    Rails.cache.fetch("genre_id_#{self[:genre]}", expires_in: 1.hour) do
      WorkType.with_deleted.find_by(genre: self[:genre], category_flag: true).id
    end
  end

  def cost_only?
    return self.cost_flag && !self.land_flag
  end

  def genre_name
    Rails.cache.fetch("genre_name_#{self[:genre]}", expires_in: 1.hour) do
      WorkType.with_deleted.find_by(genre: self[:genre], category_flag: true).name
    end
  end

  def name_format
    genre_name + "(#{name})"
  end

  def update_cost_flag
    self.cost_flag = true if self.land_flag
  end
end
