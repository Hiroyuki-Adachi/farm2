# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                  :integer          not null, primary key
#  account_number(口座番号)          :string(7)        default("0000000"), not null
#  bank_code(口座(金融機関))         :string(4)        default("0000"), not null
#  birthday(誕生日)                  :date
#  branch_code(口座(支店))           :string(3)        default("000"), not null
#  broccoli_mark(ブロッコリ記号)     :string(1)
#  deleted_at                        :datetime
#  display_order(表示順)             :integer
#  family_name(姓)                   :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))   :string(15)       not null
#  first_name(名)                    :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))    :string(15)       not null
#  mobile(携帯番号)                  :string(15)
#  mobile_mail(メールアドレス(携帯)) :string(50)
#  office_role(事務の役割)           :integer          default("none"), not null
#  pc_mail(メールアドレス(PC))       :string(50)
#  work_flag(作業フラグ)             :boolean          default(TRUE), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  account_type_id(口座種別)         :integer          default(0), not null
#  gender_id(性別)                   :integer          default("none"), not null
#  home_id(世帯)                     :integer
#  position_id(役職)                 :integer          default("none"), not null
#
# Indexes
#
#  index_workers_on_deleted_at  (deleted_at)
#

require 'securerandom'

class Worker < ApplicationRecord
  include Discard::Model
  include Enums::OfficeRole

  self.discard_column = :deleted_at

  belongs_to :home, -> {with_deleted}

  enum :gender_id, {none: 0, male: 1, female: 2}, prefix: true
  enum :position_id, {none: 0, member: 1, leader: 2, director: 3, advisor: 9}, prefix: true

  before_save :set_user_permission_id, if: -> { user.present? }

  has_many :work_results, dependent: :restrict_with_error
  has_many :works, -> {order(:worked_at)}, through: :work_results
  has_many :task_reads, dependent: :destroy

  has_one :user

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :taskable, -> {kept.where.not(office_role: :none)}
  scope :usual, -> {kept.includes(home: :section).where(homes: { company_flag: false }).order('sections.display_order, homes.display_order, workers.display_order')}
  scope :company, -> {kept.joins(:home).eager_load(:home).where(homes: { company_flag: true }).order("workers.display_order")}
  scope :by_homes, ->(homes) {kept.where(home_id: homes.ids).order("display_order")}
  scope :gaps, -> {kept.where.not(broccoli_mark: [nil, ""]).order(:broccoli_mark, :family_phonetic, :first_phonetic, :id)}

  REG_MAIL = /\A([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+\z/
  REG_MOBILE = /\A(090|080|070)-\d{4}-\d{4}\z/
  REG_KANA = /\A[\p{Hiragana}]+/

  validates :family_phonetic, presence: true
  validates :family_name, presence: true
  validates :first_phonetic, presence: true
  validates :first_name, presence: true
  validates :display_order, presence: true

  validates :family_phonetic, format: {with: REG_KANA}, :if => proc { |x| x.family_phonetic.present?}
  validates :first_phonetic,  format: {with: REG_KANA}, :if => proc { |x| x.first_phonetic.present?}

  validates :mobile, format: {with: REG_MOBILE}, :if => proc { |x| x.mobile.present?}
  validates :pc_mail, format: {with: REG_MAIL}, :if => proc { |x| x.pc_mail.present?}
  validates :mobile_mail, format: {with: REG_MAIL}, :if => proc { |x| x.mobile_mail.present?}

  validates :display_order, numericality: {only_integer: true}, :if => proc { |x| x.display_order.present?}
  validates :broccoli_mark, uniqueness: true, :if => proc { |x| x.broccoli_mark.present?}
  validate :office_role_only_user

  def name
    "#{family_name} #{first_name}"
  end

  def phonetic
    "#{family_phonetic} #{first_phonetic}"
  end

  def payment
    home.worker_payment_flag ? self : home.holder
  end

  def member?
    self.position_id_member?
  end

  def leader?
    self.position_id_leader?
  end

  def director?
    self.position_id_director?
  end

  def advisor?
    self.position_id_advisor?
  end

  def position_name
    I18n.t("activerecord.enums.worker.position_ids.#{self.position_id}")
  end

  private

  def office_role_only_user
    errors.add(:office_role, "を設定する場合は、先にユーザを登録してください。") if self.user.blank? && !self.office_role_none?
  end

  def set_user_permission_id
    self.user.update(permission_id: :checker) unless self.user.checkable?
  end

  private

  def set_email
    self.user.email = (self.pc_mail.presence || '') if self.user.present?
    self.user.save!
  end
end
