# == Schema Information
#
# Table name: workers(作業者マスタ)
#
#  id(作業者マスタ)                        :integer          not null, primary key
#  account_holder_name(口座氏名(半角カナ)) :string(30)       default(""), not null
#  account_number(口座番号)                :string(7)        default("0000000"), not null
#  bank_code(銀行コード)                   :string(4)        default("0000"), not null
#  birthday(誕生日)                        :date
#  branch_code(支店コード)                 :string(3)        default("000"), not null
#  broccoli_mark(ブロッコリ記号)           :string(1)
#  deleted_at                              :datetime
#  display_order(表示順)                   :integer
#  family_name(姓)                         :string(10)       not null
#  family_phonetic(姓(ﾌﾘｶﾞﾅ))         :string(15)       not null
#  first_name(名)                          :string(10)       not null
#  first_phonetic(名(ﾌﾘｶﾞﾅ))          :string(15)       not null
#  mobile(携帯番号)                        :string(15)
#  mobile_mail(メールアドレス(携帯))       :string(50)
#  office_role(事務の役割)                 :integer          default("none"), not null
#  pc_mail(メールアドレス(PC))             :string(50)
#  work_flag(作業フラグ)                   :boolean          default(TRUE), not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  account_type_id(口座種別)               :integer          default("unset"), not null
#  gender_id(性別)                         :integer          default("none"), not null
#  home_id(世帯)                           :integer
#  organization_id(組織)                   :bigint           default(1), not null
#  position_id(役職)                       :integer          default("none"), not null
#
# Indexes
#
#  index_workers_on_deleted_at       (deleted_at)
#  index_workers_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

require 'securerandom'

class Worker < ApplicationRecord
  include Discard::Model
  include Enums::OfficeRole
  include ZenginAccount

  self.discard_column = :deleted_at

  belongs_to :organization, optional: true
  belongs_to :home, -> { with_deleted }

  enum :gender_id, { none: 0, male: 1, female: 2 }, prefix: true
  enum :position_id, { none: 0, member: 1, leader: 2, director: 3, advisor: 9 }, prefix: true
  enum :account_type_id, { unset: 0, regular: 1, current: 2, savings: 4 }, prefix: true

  before_save :set_user_permission_id, if: -> { user.present? }

  has_many :work_results, dependent: :restrict_with_error
  has_many :works, -> { order(:worked_at) }, through: :work_results
  has_many :task_reads, dependent: :destroy

  has_one :user, dependent: :restrict_with_error

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }
  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :taskable, -> { kept.where.not(office_role: :none) }
  scope :workable, -> { where(work_flag: true) }
  scope :usual_order, -> { kept.includes(home: :section).order('sections.display_order, homes.display_order, workers.display_order') }
  scope :usual, -> { kept.where(homes: { company_flag: false }).usual_order }
  scope :company, -> { kept.joins(:home).eager_load(:home).where(homes: { company_flag: true }).order("workers.display_order") }
  scope :by_homes, ->(homes) { kept.where(home_id: homes.ids).order(:display_order) }
  scope :gaps, -> { kept.where.not(broccoli_mark: [nil, ""]).order(:broccoli_mark, :family_phonetic, :first_phonetic, :id) }

  REG_MAIL = /\A([a-zA-Z0-9])+([a-zA-Z0-9._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9._-]+)+\z/
  REG_MOBILE = /\A(090|080|070)-\d{4}-\d{4}\z/
  REG_KANA = /\A\p{Hiragana}+/
  REG_HALF_WIDTH = /\A[ -~｡-ﾟ]+\z/

  validates :family_phonetic, presence: true
  validates :family_name, presence: true
  validates :first_phonetic, presence: true
  validates :first_name, presence: true
  validates :display_order, presence: true

  validates :family_phonetic, format: { with: REG_KANA }, if: proc { |x| x.family_phonetic.present? }
  validates :first_phonetic,  format: { with: REG_KANA }, if: proc { |x| x.first_phonetic.present? }

  validates :mobile, format: { with: REG_MOBILE }, if: proc { |x| x.mobile.present? }
  validates :pc_mail, format: { with: REG_MAIL }, if: proc { |x| x.pc_mail.present? }
  validates :mobile_mail, format: { with: REG_MAIL }, if: proc { |x| x.mobile_mail.present? }
  validates :bank_code, length: { is: 4 }, format: { with: /\A\d+\z/ }, if: proc { |x| x.bank_code.present? }
  validates :branch_code, length: { is: 3 }, format: { with: /\A\d+\z/ }, if: proc { |x| x.branch_code.present? }
  validates :account_number, length: { is: 7 }, format: { with: /\A\d+\z/ }, if: proc { |x| x.account_number.present? }
  validates :account_holder_name, length: { maximum: 30 }, if: proc { |x| x.account_holder_name.present? }
  validates :account_holder_name, format: { with: REG_HALF_WIDTH }, if: proc { |x| x.account_holder_name.present? }

  validates :display_order, numericality: { only_integer: true }, if: proc { |x| x.display_order.present? }
  validates :broccoli_mark, uniqueness: true, if: proc { |x| x.broccoli_mark.present? }
  validate :office_role_only_user
  validate :home_belongs_to_same_organization

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
    position_id_member?
  end

  def leader?
    position_id_leader?
  end

  def director?
    position_id_director?
  end

  def advisor?
    position_id_advisor?
  end

  def position_name
    I18n.t("activerecord.enums.worker.position_ids.#{position_id}")
  end

  def account_incomplete?
    bank_account_incomplete? || account_holder_name.blank?
  end

  private

  def office_role_only_user
    errors.add(:office_role, "を設定する場合は、先にユーザを登録してください。") if user.blank? && !office_role_none?
  end

  def home_belongs_to_same_organization
    return if organization_id.blank? || home.blank? || home.organization_id == organization_id

    errors.add(:home_id, "は同じ組織の世帯を指定してください。")
  end

  def set_user_permission_id
    user.update(permission_id: :checker) unless user.checkable?
  end

  def set_email
    user.email = (pc_mail.presence || '') if user.present?
    user.save!
  end
end
