# == Schema Information
#
# Table name: work_types
#
#  id            :integer          not null, primary key
#  genre         :integer          not null
#  name          :string(10)       not null
#  category_flag :boolean          default(FALSE)
#  display_order :integer          default(0), not null
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
    return WorkType.with_deleted.where(genre: self[:genre], category_flag: true).first.id
  end

  def genre_name
    return WorkType.with_deleted.where(genre: self[:genre], category_flag: true).first.name
  end

  def name_format
    return genre_name + "(#{self.name})"
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
