# == Schema Information
#
# Table name: workers
#
#  id              :integer          not null, primary key
#  family_phonetic :string(15)       not null
#  family_name     :string(10)       not null
#  first_phonetic  :string(15)       not null
#  first_name      :string(10)       not null
#  birthday        :date
#  home_id         :integer
#  mobile          :string(15)
#  mobile_mail     :string(50)
#  pc_mail         :string(50)
#  display_order   :integer
#  work_flag       :boolean          default("true"), not null
#  gender_id       :integer          default("0"), not null
#  bank_code       :string(4)        default("0000"), not null
#  branch_code     :string(3)        default("000"), not null
#  account_type_id :integer          default("0"), not null
#  account_number  :string(7)        default("0000000"), not null
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#  token           :string(36)       default(""), not null
#  position_id     :integer          default("0"), not null
#  broccoli_mark   :string(1)
#
# Indexes
#
#  index_workers_on_deleted_at  (deleted_at)
#  index_workers_on_token       (token) UNIQUE
#

require 'securerandom'

class Worker < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  acts_as_paranoid

  before_create :set_token

  belongs_to :home, -> {with_deleted}
  belongs_to_active_hash :position
  belongs_to_active_hash :gender

  has_many :work_results
  has_many :works, -> {order(:worked_at)}, through: :work_results

  has_one :user

  scope :usual, -> {includes(home: :section).where(["homes.company_flag = ?", false]).order('sections.display_order, homes.display_order, workers.display_order')}
  scope :company, -> {joins(:home).eager_load(:home).where(["homes.company_flag = ?", true]).order("workers.display_order")}
  scope :by_homes, ->(homes) {where(home_id: homes.ids).order("display_order")}

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
    family_name + ' ' + first_name
  end

  def phonetic
    family_phonetic + ' ' + first_phonetic
  end

  def payment
    home.worker_payment_flag ? self : home.holder
  end

  def set_token
    self.token = SecureRandom.uuid
  end
end
