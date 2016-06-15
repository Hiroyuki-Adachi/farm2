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
#  member_flag         :boolean          default(TRUE), not null
#  worker_payment_flag :boolean          default(FALSE), not null
#  company_flag        :boolean          default(FALSE), not null
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#

class Home < ActiveRecord::Base
  acts_as_paranoid

  REG_PHONE = /\A\d{2,4}-\d{2,4}-\d{4}\z/

  has_many :workers,  ->{order(:display_order)}
  has_many :owned_lands,    ->{order(:place)}, {class_name: :Land, foreign_key: :owner_id}
  has_many :managed_lands,  ->{order(:place)}, {class_name: :Land, foreign_key: :manager_id}
  
  belongs_to :holder, -> {with_deleted}, {class_name: :Worker, foreign_key: :worker_id}
  belongs_to :section

  scope :usual, ->{includes(:section).where(member_flag: true, company_flag: false).order("sections.display_order, homes.display_order, homes.id")}
  scope :list, ->{includes(:section, :holder).where(company_flag: false).order("sections.display_order, homes.display_order, homes.id")}
  scope :machine_owners, ->{where("member_flag = ? OR company_flag = ?", true, true).order("company_flag DESC, display_order, id")}

  validates :phonetic,      presence: true
  validates :name,          presence: true
  validates :display_order, presence: true
  
  validates :phonetic, format: {with: /\A[\p{Hiragana}ー－]+\z/}, :if => Proc.new{|x| x.phonetic.present?}
  validates :telephone, format: {with: REG_PHONE}, :if => Proc.new{|x| x.telephone.present?}
  
  validates :display_order, numericality: {only_integer: true}, :if => Proc.new{|x| x.display_order.present?}

  def holder_name
    return self.holder ? self.holder.name : ''
  end
end
