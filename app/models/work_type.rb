class WorkType < ActiveRecord::Base
  acts_as_paranoid

  GENRE_RICE    = 1;
  GENRE_CHANGE  = 2;
  GENRE_SUB     = 3;
  GENRE_COMMON  = 4;

  named_scope :rice,    :conditions => ['genre = ? and category_flag = ?', GENRE_RICE, false],   :order => 'display_order, id'
  named_scope :change,  :conditions => ['genre = ? and category_flag = ?', GENRE_CHANGE, false], :order => 'display_order, id'
  named_scope :sub,     :conditions => ['genre = ? and category_flag = ?', GENRE_SUB, false],    :order => 'display_order, id'
  named_scope :common,  :conditions => ['genre = ? and category_flag = ?', GENRE_COMMON, false], :order => 'display_order, id'

  def genre_name
    return WorkType.find(:first, :conditions => ['genre = ? and category_flag = ?', self.genre, true]).name
  end

  def name_format
    return genre_name + "(#{self.name})"
  end

  def self.rice_id
    return WorkType.find(:first, :conditions => ['genre = ? and category_flag = ?', GENRE_RICE, true]).id
  end

  def self.change_id
    return WorkType.find(:first, :conditions => ['genre = ? and category_flag = ?', GENRE_CHANGE, true]).id
  end

  def self.sub_id
    return WorkType.find(:first, :conditions => ['genre = ? and category_flag = ?', GENRE_SUB, true]).id
  end

  def self.common_id
    return WorkType.find(:first, :conditions => ['genre = ? and category_flag = ?', GENRE_COMMON, true]).id
  end

end
