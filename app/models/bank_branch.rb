# == Schema Information
#
# Table name: bank_branches # 支店マスタ
#
#  address1(住所1)                :string(50)
#  address2(住所2)                :string(50)
#  bank_code(金融機関コード)      :string(4)        not null, primary key
#  code(支店コード)               :string(3)        not null, primary key
#  fax(FAX番号)                   :string(15)
#  name(支店名称)                 :string(40)       not null
#  phonetic(支店名称(ﾌﾘｶﾞﾅ)) :string(40)       not null
#  telephone(電話番号)            :string(15)
#  zip_code(郵便番号)             :string(7)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class BankBranch < ApplicationRecord
  self.primary_keys = :bank_code, :code

  belongs_to :bank, {foreign_key: :bank_code}

  validates :bank_code, presence: true
  validates :code,      presence: true
  validates :name,      presence: true
  validates :phonetic,  presence: true

  validates :zip_code, format: {with: /\A[\d{7}]+\z/}, :if => Proc.new{|x| x.zip_code.present?}
  validates :phonetic, format: {with: /\A[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝﾞﾟ｢｣\-\(\)\\\.\s]+\z/}, :if => Proc.new{|x| x.phonetic.present?}
end
