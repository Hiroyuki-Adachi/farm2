# == Schema Information
#
# Table name: users
#
#  id(利用者マスタ)              :integer          not null, primary key
#  calendar_term(期(カレンダー)) :integer          default(2018), not null
#  login_name(ログイン名)        :string(12)       not null
#  password_digest(パスワード)   :string(128)      not null
#  target_from(開始年月)         :date             default(Fri, 01 Jan 2010), not null
#  target_to(終了年月)           :date             default(Fri, 31 Dec 2010), not null
#  term(期)                      :integer          default(0), not null
#  token(アクセストークン)       :string(36)       default(""), not null
#  view_month(表示切替月)        :integer          default(["1", "4", "8"]), not null, is an Array
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  organization_id(組織)         :integer          default(0), not null
#  permission_id(権限)           :integer          default(0), not null
#  worker_id(作業者)             :integer
#
# Indexes
#
#  index_users_on_login_name  (login_name) UNIQUE
#  index_users_on_worker_id   (worker_id) UNIQUE
#  ix_users_token             (token) UNIQUE
#

class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  MAX_DESCRIPTOR_SIZE = 20

  before_create :set_token

  belongs_to :worker
  belongs_to :organization
  belongs_to_active_hash :permission

  has_many :calendar_work_kinds, dependent: :destroy
  has_many :user_words, dependent: :destroy
  has_many :user_topics, dependent: :destroy
  has_many :topics, through: :user_topics
  has_many :face_descriptors, dependent: :destroy
  has_one :user_token, dependent: :destroy

  accepts_nested_attributes_for :user_words

  validates :login_name, uniqueness: true
  validates :password, length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }

  scope :tabletable, -> {where.not(pin_digest: '')}

  scope :by_section, ->(section_id) { 
    joins(worker: {home: :section})
    .where(sections: { id: section_id })
    .order("workers.family_phonetic, workers.first_phonetic") 
  }

  def login_name=(value)
    super(value.downcase)
  end

  def admin?
    permission == Permission::ADMIN
  end

  def manager?
    permission == Permission::MANAGER
  end

  def checker?
    permission == Permission::CHECKER
  end

  def user?
    permission == Permission::USER
  end

  def visitor?
    permission == Permission::VISITOR
  end

  def manageable?
    admin? || manager?
  end

  def checkable?
    admin? || manager? || checker?
  end

  def descriptor_enough?
    face_descriptors.size >= MAX_DESCRIPTOR_SIZE
  end

  def same_face?(descriptor, threshold = 0.6)
    user = User.find_similar_face(self.organization_id, descriptor, threshold)
    return false if user.nil?
    return user.id == self.id
  end

  def self.find_similar_face(organization_id, descriptor, threshold = 0.6)
    FaceDescriptor.by_organization(organization_id).find_each do |face_descriptor|
      return face_descriptor.user if face_descriptor.distance_from(descriptor) < threshold
    end
    return nil
  end
  
  def regenerate_token!
    if user_token
      user_token.update!(token: nil)
    else
      create_user_token!
    end
  end

  private

  def set_token
    self.token = SecureRandom.uuid
  end

  has_secure_password
end
