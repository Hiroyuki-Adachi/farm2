# == Schema Information
#
# Table name: homes # 世帯マスタ
#
#  id                  :integer          not null, primary key    # 世帯マスタ
#  phonetic            :string(15)                                # 世帯名(よみ)
#  name                :string(10)                                # 世帯名
#  worker_id           :integer                                   # 世帯主(代表者)
#  zip_code            :string(7)                                 # 郵便番号
#  address1            :string(50)                                # 住所1
#  address2            :string(50)                                # 住所2
#  telephone           :string(15)                                # 電話番号
#  fax                 :string(15)                                # FAX番号
#  section_id          :integer                                   # 班／町内
#  display_order       :integer                                   # 表示順
#  member_flag         :boolean          default(TRUE), not null  # 組合員フラグ
#  worker_payment_flag :boolean          default(FALSE), not null # 個人支払フラグ
#  company_flag        :boolean          default(FALSE), not null # 営農組合フラグ
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  owner_flag          :boolean          default(FALSE), not null # 所有者フラグ
#  finance_order       :integer                                   # 出力順(会計用)
#  drying_order        :integer                                   # 出力順(乾燥調整用)
#  owned_rice_order    :integer                                   # 出力順(保有米)
#

class Home < ApplicationRecord
  acts_as_paranoid

  REG_PHONE = /\A\d{2,4}-\d{2,4}-\d{4}\z/

  has_many :workers, -> {order(:display_order)}
  has_many :owned_lands,    -> {order(:place)}, {class_name: :Land, foreign_key: :owner_id}
  has_many :managed_lands,  -> {order(:place)}, {class_name: :Land, foreign_key: :manager_id}

  belongs_to :holder,  -> {with_deleted}, {class_name: :Worker, foreign_key: :worker_id, optional: true}
  belongs_to :section, -> {with_deleted}

  scope :usual, -> {
    includes(:section)
      .where(["sections.work_flag = ?", true])
      .order(Arel.sql("sections.display_order, homes.display_order, homes.id"))
  }
  scope :list, -> {
    includes(:section, :holder)
      .where(company_flag: false)
      .order(Arel.sql("sections.display_order, homes.display_order, homes.id"))
  }
  scope :landable, -> {
    joins(:section)
      .order(Arel.sql("homes.company_flag, sections.display_order, homes.display_order, homes.id"))
  }
  scope :machine_owners, -> {where(owner_flag: true).order(Arel.sql("company_flag DESC, display_order, id"))}
  scope :company, ->{where(company_flag: true)}
  scope :for_finance1, -> {where(member_flag: true, owner_flag: true).order(finance_order: :ASC, id: :ASC)}
  scope :for_drying, -> {where.not(drying_order: nil).order(:drying_order)}
  scope :for_owned_rice, -> {
    where(member_flag: true, owner_flag: true)
      .order(owned_rice_order: :ASC, display_order: :ASC, id: :ASC)
  }

  validates :phonetic,      presence: true
  validates :name,          presence: true
  validates :display_order, presence: true
  validates :phonetic, format: { with: /\A[\p{Hiragana}ー－]+\z/ }, if: proc { |x| x.phonetic.present?}
  validates :telephone, format: {with: REG_PHONE}, if: proc { |x| x.telephone.present? }
  validates :display_order, numericality: {only_integer: true}, if: proc { |x| x.display_order.present?}

  def holder_name
    holder ? holder.name : ''
  end

  def owner_name
    holder && !company_flag ? holder.name + '(' + name + ')' : name
  end

  def home_display_order
    display_order * 100 + id
  end

  def finance_code
    finance_order ? finance_order.to_s.insert(1, "-") : ""
  end

  def owned_area
    owned_lands.sum(:area)
  end

  def owned_rice_limit
    (owned_area / 10 * OwnedRice::OWNED_RICE_COUNT).floor
  end
end
