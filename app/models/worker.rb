# == Schema Information
#
# Table name: workers
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
#  pc_mail(メールアドレス(PC))       :string(50)
#  work_flag(作業フラグ)             :boolean          default(TRUE), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  account_type_id(口座種別)         :integer          default(0), not null
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
  extend ActiveHash::Associations::ActiveRecordExtensions
  acts_as_paranoid

  belongs_to :home, -> {with_deleted}
  belongs_to_active_hash :position
  belongs_to_active_hash :gender

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
    position == Position::MEMBER
  end

  def leader?
    position == Position::LEADER
  end

  def director?
    position == Position::DIRECTOR
  end

  def advisor?
    position == Position::ADVISOR
  end
end
