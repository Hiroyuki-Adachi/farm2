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
  belongs_to :genre, class_name: "WorkGenre", foreign_key: "work_genre_id"

  has_one :plan, class_name: "PlanWorkType", dependent: :destroy
  has_many :work_type_terms

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :usual_order, -> { joins(genre: :category).order("work_categories.display_order ASC, work_types.display_order ASC, work_types.id ASC") }
  scope :usual, -> {kept.where(work_flag: true).usual_order}
  scope :indexes, -> {kept.usual_order}
  scope :land, -> {kept.where(land_flag: true).usual_order}
  scope :cost, -> {kept.where(cost_flag: true).usual_order}
  scope :select_category, ->(category) {kept.joins(:genre).where("work_flag = true AND work_genres.work_category_id = ?", category.id).usual_order}
  scope :by_term, ->(term) {
    where("EXISTS (SELECT * FROM work_type_terms WTT WHERE work_types.id = WTT.work_type_id AND WTT.term = ?)", term)
    .with_discarded
    .usual_order
  }
  scope :for_work, ->(category, work) {
    joins(:genre)
    .where(<<SQL.squish, category: category.id, term: work.term, id: work.work_type_id, work_category: work.work_type.genre.work_category_id)
    (work_flag = TRUE AND work_genres.work_category_id = :category AND EXISTS (SELECT * FROM work_type_terms WTT WHERE work_types.id = WTT.work_type_id AND WTT.term = :term)) OR (work_types.id = :id AND :category = :work_category)
SQL
    .with_deleted
    .order(display_order: :ASC, id: :ASC)
  }

  attr_accessor :term, :term_flag

  def cost_only?
    return self.cost_flag && !self.land_flag
  end

  def category_name
    genre.category.name
  end

  def name_format
    category_name + "(#{name})"
  end

  def bg_color_term(term)
    return work_type_terms.find_by(term: term)&.bg_color || self.bg_color || '#ffffff'
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
