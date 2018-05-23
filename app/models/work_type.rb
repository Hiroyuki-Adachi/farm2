# == Schema Information
#
# Table name: work_types # 作業分類マスタ
#
#  id            :integer          not null, primary key   # 作業分類マスタ
#  genre         :integer          not null                # 作業ジャンル
#  name          :string(10)       not null                # 作業分類名称
#  category_flag :boolean          default(FALSE)          # カテゴリーフラグ
#  display_order :integer          default(0), not null    # 表示順
#  deleted_at    :datetime
#  bg_color      :string(8)                                # 背景色
#  land_flag     :boolean          default(TRUE), not null # 土地利用
#

class WorkType < ApplicationRecord
  acts_as_paranoid

  scope :categories, -> {where(category_flag: true).order(display_order: :ASC, id: :ASC)}
  scope :usual, -> {order(category_flag: :ASC, display_order: :ASC, id: :ASC)}
  scope :index, -> {where(category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}

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

  def self.select_category(category)
    WorkType.where(category_flag: false, genre: category[:genre]).order(display_order: :ASC, id: :ASC)
  end
end
