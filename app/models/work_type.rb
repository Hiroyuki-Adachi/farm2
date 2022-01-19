# == Schema Information
#
# Table name: work_types
#
#  id            :integer          not null, primary key
#  genre         :integer          not null
#  name          :string(10)       not null
#  category_flag :boolean          default("false")
#  display_order :integer          default("0"), not null
#  deleted_at    :datetime
#  bg_color      :string(8)
#  land_flag     :boolean          default("true"), not null
#  icon_name     :string(40)
#  icon          :binary
#  cost_flag     :boolean          default("false"), not null
#  work_flag     :boolean          default("true"), not null
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
  scope :land, -> {where(land_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :cost, -> {where(cost_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
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
