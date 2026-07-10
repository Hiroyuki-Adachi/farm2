# == Schema Information
#
# Table name: banks(金融機関マスタ)
#
#  id                       :bigint           not null, primary key
#  code(金融機関コード)     :string(4)        not null
#  kana(金融機関名称(カナ)) :string(40)       default(""), not null
#  name(金融機関名称)       :string(40)       not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_banks_on_code  (code) UNIQUE
#
class Bank < ApplicationRecord
  has_many :bank_branches, foreign_key: :bank_code, primary_key: :code, inverse_of: :bank, dependent: :destroy

  validates :code, presence: true, length: { is: 4 }, format: { with: /\A\d{4}\z/ }, uniqueness: true
  validates :name, presence: true

  scope :usual, -> { order(:code) }
end
