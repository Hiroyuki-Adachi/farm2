# == Schema Information
#
# Table name: work_types # 作業分類マスタ
#
#  id            :integer          not null, primary key # 作業分類マスタ
#  genre         :integer          not null              # 作業ジャンル
#  name          :string(10)       not null              # 作業分類名称
#  category_flag :boolean          default(FALSE)        # カテゴリーフラグ
#  display_order :integer          default(0), not null  # 表示順
#  deleted_at    :datetime
#

class WorkType < ActiveRecord::Base
  acts_as_paranoid

  enum genre: {rice: 1, change: 2, sub: 3, common: 4}

  scope :categories,  -> {where(category_flag: true).order(:display_order, :id)}
  scope :rices,       -> {where(genre: WorkType.genres[:rice], category_flag: false).order(:display_order, :id)}
  scope :changes,     -> {where(genre: WorkType.genres[:change], category_flag: false).order(:display_order, :id)}
  scope :subs,        -> {where(genre: WorkType.genres[:sub], category_flag: false).order(:display_order, :id)}
  scope :commons,     -> {where(genre: WorkType.genres[:common], category_flag: false).order(:display_order, :id)}
  scope :usual,       -> {order(:category_flag, :display_order, :id)}

  def genre_id
    Rails.cache.fetch("genre_id_#{self[:genre]}") do
      WorkType.with_deleted.where(genre: self[:genre], category_flag: true).first.id
    end
  end

  def genre_name
    Rails.cache.fetch("genre_name_#{self[:genre]}") do
      WorkType.with_deleted.where(genre: self[:genre], category_flag: true).first.name
    end
  end

  def name_format
    return genre_name + "(#{name})"
  end

  def self.select_category(category)
    return WorkType.where(category_flag: false, genre: category[:genre]).order(:display_order, :id)
  end

  def self.category_rice
    return WorkType.rice.where(category_flag: true).first
  end

  def self.category_change
    return WorkType.change.where(category_flag: true).first
  end

  def self.category_sub
    return WorkType.sub.where(category_flag: true).first
  end

  def self.category_common
    return WorkType.common.where(category_flag: true).first
  end
end
