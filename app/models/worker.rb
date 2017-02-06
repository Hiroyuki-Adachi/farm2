# == Schema Information
#
# Table name: workers # 作業者マスタ
#
#  id              :integer          not null, primary key        # 作業者マスタ
#  family_phonetic :string(15)       not null                     # 姓(ﾌﾘｶﾞﾅ)
#  family_name     :string(10)       not null                     # 姓
#  first_phonetic  :string(15)       not null                     # 名(ﾌﾘｶﾞﾅ)
#  first_name      :string(10)       not null                     # 名
#  birthday        :date                                          # 誕生日
#  home_id         :integer                                       # 世帯
#  mobile          :string(15)                                    # 携帯番号
#  mobile_mail     :string(50)                                    # メールアドレス(携帯)
#  pc_mail         :string(50)                                    # メールアドレス(PC)
#  display_order   :integer                                       # 表示順
#  work_flag       :boolean          default(TRUE), not null      # 作業フラグ
#  gender_id       :integer          default(0), not null         # 性別
#  bank_code       :string(4)        default("0000"), not null    # 口座(金融機関)
#  branch_code     :string(3)        default("000"), not null     # 口座(支店)
#  account_type_id :integer          default(0), not null         # 口座種別
#  account_number  :string(7)        default("0000000"), not null # 口座番号
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#

class Worker < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  acts_as_paranoid
  
  belongs_to :home, -> {with_deleted}
  belongs_to :gender

  has_many :work_results
  has_many :works, ->{order(:worked_at)}, through: :work_results

  scope :usual, ->{includes({home: :section}).order('sections.display_order, homes.display_order, workers.display_order')}

  REG_MAIL = /\A([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+\z/

  validates :family_phonetic, presence: true
  validates :family_name, presence: true
  validates :first_phonetic, presence: true
  validates :first_name, presence: true
  validates :display_order, presence: true

  validates :family_phonetic, format: {with: /\A[\p{Hiragana}ー－]+\z/}, :if => Proc.new{|x| x.family_phonetic.present?}
  validates :first_phonetic,  format: {with: /\A[\p{Hiragana}ー－]+\z/}, :if => Proc.new{|x| x.first_phonetic.present?}

  validates :mobile, format: {with: /\A(090|080|070)-\d{4}-\d{4}\z/}, :if => Proc.new{|x| x.mobile.present?}
  validates :pc_mail, format: {with: REG_MAIL},  :if => Proc.new{|x| x.pc_mail.present?}
  validates :mobile_mail, format: {with: REG_MAIL},  :if => Proc.new{|x| x.mobile_mail.present?}

  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def name
    return self.family_name + ' ' + self.first_name
  end

  def phonetic
    return self.family_phonetic + ' ' + self.first_phonetic
  end
  
  def payment
    return self.home.worker_payment_flag ? self : self.home.holder
  end
end
