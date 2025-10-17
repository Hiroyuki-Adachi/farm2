# == Schema Information
#
# Table name: work_types(作業分類マスタ)
#
#  id(作業分類マスタ)          :integer          not null, primary key
#  bg_color(背景色)            :string(8)
#  cost_flag(原価フラグ)       :boolean          default(FALSE), not null
#  deleted_at                  :datetime
#  display_order(表示順)       :integer          default(0), not null
#  icon(アイコン)              :binary
#  icon_name(アイコン名)       :string(40)
#  icon_updated_at             :datetime
#  land_flag(土地利用)         :boolean          default(TRUE), not null
#  name(作業分類名称)          :string(10)       not null
#  office_role(事務の役割)     :integer          default("none"), not null
#  other_flag(その他フラグ)    :boolean          default(FALSE), not null
#  work_flag(日報フラグ)       :boolean          default(TRUE), not null
#  work_genre_id(作業ジャンル) :bigint           not null
#
# Indexes
#
#  index_work_types_on_deleted_at     (deleted_at)
#  index_work_types_on_work_genre_id  (work_genre_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_genre_id => work_genres.id)
#

class WorkType < ApplicationRecord
  include Discard::Model
  include Enums::OfficeRole

  self.discard_column = :deleted_at

  before_save :update_cost_flag
  before_save :touch_icon_timestamp, if: :will_save_change_to_icon?
  after_save :save_work_type_term

  has_one :plan, class_name: "PlanWorkType", dependent: :destroy
  has_many :work_type_terms

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :categories, -> {kept.where(category_flag: true).order(display_order: :ASC, id: :ASC)}
  scope :usual, -> {kept.where(work_flag: true).order(category_flag: :ASC, display_order: :ASC, id: :ASC)}
  scope :indexes, -> {kept.where(category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :land, -> {kept.where(land_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :cost, -> {kept.where(cost_flag: true, category_flag: false).order(genre: :ASC, display_order: :ASC, id: :ASC)}
  scope :select_category, ->(category) {kept.where(category_flag: false, work_flag: true, genre: category[:genre]).order(display_order: :ASC, id: :ASC)}
  scope :by_term, ->(term) {
    where("EXISTS (SELECT * FROM work_type_terms WTT WHERE work_types.id = WTT.work_type_id AND WTT.term = ?)", term)
    .with_deleted
  }
  scope :for_work, ->(category, work) {
    where(<<SQL.squish, category[:genre], work.term, work.work_type_id, category[:genre], work.work_type&.genre_id)
    (category_flag = FALSE AND work_flag = TRUE AND genre = ? AND EXISTS (SELECT * FROM work_type_terms WTT WHERE work_types.id = WTT.work_type_id AND WTT.term = ?)) OR (id = ? AND ? = ?)
SQL
    .with_deleted
    .order(display_order: :ASC, id: :ASC)
  }

  attr_accessor :term, :term_flag

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

  def bg_color_term(term)
    return work_type_terms.find_by(term: term)&.bg_color || self.bg_color
  end

  def bg_color_date(organization, date)
    return bg_color_term(organization.get_term(date))
  end

  def fg_color
    return WorkType.to_fg_color(self.bg_color)
  end

  def exists_term?(term)
    return work_type_terms.exists?(term: term)
  end

  def fg_color_term(term)
    return WorkType.to_fg_color(self.bg_color_term(term))
  end

  def fg_color_date(organization, date)
    return fg_color_term(organization.get_term(date))
  end

  def icon_fingerprint
    return nil if icon.blank?
    @icon_fingerprint ||= Digest::SHA256.hexdigest(icon)
  end

  def self.to_fg_color(bg_color)
    rgb = {r: 255, g: 255, b: 255 }
    lum = 135
  
    if bg_color[0, 1] == '#' && bg_color.length == 7
      rgb[:r] = bg_color[1, 2].to_i(16)
      rgb[:g] = bg_color[3, 2].to_i(16)
      rgb[:b] = bg_color[5, 2].to_i(16)
    end

    yuv = (0.2126 * rgb[:r]) + (0.7152 * rgb[:g]) + (0.0722 * rgb[:b])
  
    return yuv >= lum ? 'black' : 'white'
  end

  def self.find_other
    find_by(other_flag: true)
  end

  def icon_last_modified
    self.icon_updated_at
  end

  private

  def update_cost_flag
    self.cost_flag = true if self.land_flag
  end

  def save_work_type_term
    work_term = WorkTypeTerm.find_by(term: @term, work_type_id: self.id)
    if @term_flag
      work_term ||= WorkTypeTerm.new(term: @term, work_type_id: self.id)
      work_term.bg_color = self.bg_color
      work_term.save!
    elsif work_term
      work_term.destroy
    end
  end

  def touch_icon_timestamp
    self.icon_updated_at = Time.current
    @icon_fingerprint = nil # 同一インスタンス内で更新直後も再計算させる
  end
end
