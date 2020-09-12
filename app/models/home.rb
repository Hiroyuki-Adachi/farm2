# == Schema Information
#
# Table name: homes # 世帯マスタ
#
#  id(世帯マスタ)                      :integer          not null, primary key
#  address1(住所1)                     :string(50)
#  address2(住所2)                     :string(50)
#  company_flag(営農組合フラグ)        :boolean          default(FALSE), not null
#  deleted_at                          :datetime
#  display_order(表示順)               :integer
#  drying_order(出力順(乾燥調整用))    :integer
#  fax(FAX番号)                        :string(15)
#  finance_order(出力順(会計用))       :integer
#  member_flag(組合員フラグ)           :boolean          default(TRUE), not null
#  name(世帯名)                        :string(10)
#  owned_rice_order(出力順(保有米))    :integer
#  owner_flag(所有者フラグ)            :boolean          default(FALSE), not null
#  phonetic(世帯名(よみ))              :string(15)
#  seedling_order(出力順(育苗用))      :integer
#  telephone(電話番号)                 :string(15)
#  worker_payment_flag(個人支払フラグ) :boolean          default(FALSE), not null
#  zip_code(郵便番号)                  :string(7)
#  created_at                          :datetime
#  updated_at                          :datetime
#  section_id(班／町内)                :integer
#  worker_id(世帯主(代表者))           :integer
#
# Indexes
#
#  index_homes_on_deleted_at  (deleted_at)
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
  scope :for_drying, -> {where.not(drying_order: nil).order(:drying_order, id: :ASC)}
  scope :for_owned_rice, -> {
    where(member_flag: true, owner_flag: true)
      .order(owned_rice_order: :ASC, display_order: :ASC, id: :ASC)
  }
  scope :for_seedling, -> {where.not(seedling_order: nil).order(seedling_order: :ASC, id: :ASC)}

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
    owned_lands.where(target_flag: true).sum(:area)
  end

  def owned_rice_limit
    (owned_area / 10 * OwnedRice::OWNED_RICE_COUNT).ceil
  end

  def owned_count(system)
    OwnedRice.by_home(system.term, self.id).sum(:owned_count)
  end

  def owned_price(system)
    OwnedRice.by_home(system.term, self.id).inject(0) {|sum, e| sum + e.owned_price}
  end

  def relative_count(system)
    [0, owned_count(system) - owned_rice_limit].max
  end

  def relative_price(system)
    relative_count(system) * system.relative_price
  end

  def total_price(system)
    owned_price(system) + relative_price(system)
  end
end
