# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                  :integer          not null, primary key
#  birthday(誕生日)                  :date
#  broccoli_mark(ブロッコリ記号)     :string(1)
#  deleted_at                        :datetime
#  display_order(表示順)             :integer
#  family_name(姓)                   :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))   :string(15)       not null
#  first_name(名)                    :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))    :string(15)       not null
#  mobile(携帯番号)                  :string(15)
#  mobile_mail(メールアドレス(携帯)) :string(50)
#  pc_mail(メールアドレス(PC))       :string(50)
#  work_flag(作業フラグ)             :boolean          default(TRUE), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  gender_id(性別)                   :integer          default(0), not null
#  home_id(世帯)                     :integer
#  position_id(役職)                 :integer          default(0), not null
#
# Indexes
#
#  index_workers_on_deleted_at  (deleted_at)
#

require 'securerandom'

class Worker < ApplicationRecord
  acts_as_paranoid

  belongs_to :home, -> {with_deleted}

  enum :gender, { none: 0, male: 1, female: 2}, prefix: true
  enum :position, { none: 0, member: 1, leader: 2, director: 3, advisor: 9}, prefix: true

  has_many :work_results
  has_many :works, -> {order(:worked_at)}, through: :work_results

  has_one :user

  scope :usual, -> {includes(home: :section).where(homes: { company_flag: false }).order('sections.display_order, homes.display_order, workers.display_order')}
  scope :company, -> {joins(:home).eager_load(:home).where(homes: { company_flag: true }).order("workers.display_order")}
  scope :by_homes, ->(homes) {where(home_id: homes.ids).order("display_order")}
  scope :gaps, -> {where.not(broccoli_mark: [nil, ""]).order(:broccoli_mark, :family_phonetic, :first_phonetic, :id)}

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
    self.position_member?
  end

  def leader?
    self.position_leader?
  end

  def director?
    self.position_director?
  end

  def advisor?
    self.position_advisor?
  end

  def position_name
    human_attribute_enum(:position)
  end
end
