class Worker < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  acts_as_paranoid
  
  belongs_to :home
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
end
