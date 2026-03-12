# == Schema Information
#
# Table name: homes(世帯マスタ)
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
#  location(位置)                      :point
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
  include Discard::Model

  self.discard_column = :deleted_at

  REG_PHONE = /\A\d{2,4}-\d{2,4}-\d{4}\z/

  has_many :workers, -> {order(:display_order)}
  has_many :owned_lands,    -> {order(:place)}, class_name: 'Land', foreign_key: :owner_id
  has_many :managed_lands,  -> {order(:place)}, class_name: 'Land', foreign_key: :manager_id
  has_many :sub_lands,    -> {order(:place)}, class_name: 'LandHome'

  belongs_to :holder,  -> {with_discarded}, class_name: 'Worker', foreign_key: :worker_id, optional: true
  belongs_to :section, -> {with_discarded}

  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  scope :usual, -> {
    kept
    .includes(:section)
      .where(sections: { work_flag: true })
      .order(Arel.sql("sections.display_order, homes.display_order, homes.id"))
  }
  scope :list, -> {
    kept
    .includes(:section, :holder)
      .where(company_flag: false)
      .order(Arel.sql("sections.display_order, homes.display_order, homes.id"))
  }
  scope :landable, -> {
    kept
    .joins(:section).includes(:section)
      .order(Arel.sql("homes.company_flag, sections.display_order, homes.display_order, homes.id"))
  }
  scope :machine_owners, -> {kept.where(owner_flag: true).order(Arel.sql("company_flag DESC, display_order, id"))}
  scope :company, ->{kept.where(company_flag: true)}
  scope :for_finance1, -> {kept.where(member_flag: true, owner_flag: true).order(finance_order: :ASC, id: :ASC)}
  scope :for_drying, -> {kept.where.not(drying_order: nil).order(:drying_order, id: :ASC)}
  scope :for_owned_rice, -> {
    kept
    .where(member_flag: true, owner_flag: true)
      .order(owned_rice_order: :ASC, display_order: :ASC, id: :ASC)
  }
  scope :for_seedling, -> {kept.where.not(seedling_order: nil).order(seedling_order: :ASC, id: :ASC)}
  scope :for_fee, -> {kept.where("EXISTS (SELECT 1 FROM lands WHERE homes.id = lands.owner_id AND lands.deleted_at IS NULL AND lands.target_flag = TRUE)")}

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
    holder && !company_flag ? "#{holder.name}(#{name})" : name
  end

  def home_display_order
    (display_order * 100) + id
  end

  def finance_code
    finance_order ? finance_order.to_s.insert(1, "-") : ""
  end

  def owned_area(term)
    area = 0

    area += owned_lands
      .where(target_flag: true)
      .where("NOT EXISTS (SELECT * FROM land_homes LH WHERE LH.land_id = lands.id)")
      .where("? BETWEEN peasant_start_term AND peasant_end_term", term)
      .sum(:reg_area)

    area += sub_lands
      .joins(:land)
      .where(owner_flag: true)
      .where("? BETWEEN lands.peasant_start_term AND lands.peasant_end_term", term)
      .sum(:area)

    return area
  end

  def owned_rice_limit(term)
    (owned_area(term) / 10).ceil * OwnedRice::OWNED_RICE_COUNT
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

  def total_area
    owned_lands.where(target_flag: true).sum(:area)
  end

  def total_area_reg
    owned_lands.where(target_flag: true).sum(:reg_area)
  end

  def total_manage_fee(term)
    LandFee.where(term: term, land_id: owned_lands.ids).sum(:manage_fee)
  end

  def total_peasant_fee(term)
    LandFee.where(term: term, land_id: owned_lands.ids).sum(:peasant_fee)
  end
end
