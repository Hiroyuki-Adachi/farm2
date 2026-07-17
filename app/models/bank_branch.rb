# == Schema Information
#
# Table name: bank_branches(支店マスタ)
#
#  id                        :bigint           not null, primary key
#  bank_code(金融機関コード) :string(4)        not null
#  code(支店コード)          :string(3)        not null
#  kana(支店名称(カナ))      :string(40)       default(""), not null
#  name(支店名称)            :string(40)       not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_bank_branches_on_bank_code_and_code  (bank_code,code) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (bank_code => banks.code)
#
class BankBranch < ApplicationRecord
  belongs_to :bank, foreign_key: :bank_code, primary_key: :code, inverse_of: :bank_branches

  validates :bank_code, presence: true, length: { is: 4 }, format: { with: /\A\d{4}\z/ }
  validates :code, presence: true, length: { is: 3 }, format: { with: /\A\d{3}\z/ }, uniqueness: { scope: :bank_code }
  validates :name, presence: true

  scope :usual, -> { order(:bank_code, :code) }
end
