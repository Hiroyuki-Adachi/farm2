class WorkType < ActiveRecord::Base
  acts_as_paranoid

  enum genre: {rice: 1, change: 2, sub: 3, common: 4}

  scope :rices,    -> {where(genre: rice, category_flag: false).order(:display_order, :id)}
  scope :changes,  -> {where(genre: change, category_flag: false).order(:display_order, :id)}
  scope :subs,     -> {where(genre: sub, category_flag: false).order(:display_order, :id)}
  scope :commons,  -> {where(genre: common, category_flag: false).order(:display_order, :id)}

  def genre_name
    return WorkType.where(genre: self.genre, category_flag: true).first.name
  end

  def name_format
    return genre_name + "(#{self.name})"
  end

  def self.rice_id
    return WorkType.where(genre: rice, category_flag: true).first.id
  end

  def self.change_id
    return WorkType.where(genre: change, category_flag: true).first.id
  end

  def self.sub_id
    return WorkType.where(genre: sub, category_flag: true).first.id
  end

  def self.common_id
    return WorkType.where(genre: common, category_flag: true).first.id
  end

end
