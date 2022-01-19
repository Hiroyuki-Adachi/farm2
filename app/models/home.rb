# == Schema Information
#
# Table name: homes
#
#  id                  :integer          not null, primary key
#  phonetic            :string(15)
#  name                :string(10)
#  worker_id           :integer
#  zip_code            :string(7)
#  address1            :string(50)
#  address2            :string(50)
#  telephone           :string(15)
#  fax                 :string(15)
#  section_id          :integer
#  display_order       :integer
#  member_flag         :boolean          default("true"), not null
#  worker_payment_flag :boolean          default("false"), not null
#  company_flag        :boolean          default("false"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  owner_flag          :boolean          default("false"), not null
#  finance_order       :integer
#  drying_order        :integer
#  owned_rice_order    :integer
#  seedling_order      :integer
#  location            :point
#
# Indexes
#
#  index_homes_on_deleted_at  (deleted_at)
#

class Home < ApplicationRecord
  acts_as_paranoid

  REG_PHONE = /\A\d{2,4}-\d{2,4}-\d{4}\z/

  has_many :workers, -> {order(:display_order)}
  has_many :owned_lands,    -> {order(:place)}, class_name: :Land, foreign_key: :owner_id
  has_many :managed_lands,  -> {order(:place)}, class_name: :Land, foreign_key: :manager_id

  belongs_to :holder,  -> {with_deleted}, class_name: :Worker, foreign_key: :worker_id, optional: true
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
    joins(:section).includes(:section)
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
  scope :for_fee, -> {where("EXISTS (SELECT 1 FROM lands WHERE homes.id = lands.owner_id AND lands.deleted_at IS NULL AND lands.target_flag = TRUE)")}

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
    owned_lands.where(target_flag: true).sum(:reg_area)
  end

  def owned_rice_limit
    (owned_area / 10).ceil * OwnedRice::OWNED_RICE_COUNT
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
