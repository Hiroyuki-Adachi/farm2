# == Schema Information
#
# Table name: bank_branches # 支店マスタ
#
#  bank_code  :string(4)        not null, primary key # 金融機関コード
#  code       :string(3)        not null, primary key # 支店コード
#  name       :string(40)       not null              # 支店名称
#  phonetic   :string(40)       not null              # 支店名称(ﾌﾘｶﾞﾅ)
#  zip_code   :string(7)                              # 郵便番号
#  address1   :string(50)                             # 住所1
#  address2   :string(50)                             # 住所2
#  telephone  :string(15)                             # 電話番号
#  fax        :string(15)                             # FAX番号
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BankBranch < ActiveRecord::Base
  self.primary_keys = :bank_code, :code

  belongs_to :bank, {foreign_key: :bank_code}

  validates :bank_code, presence: true
  validates :code,      presence: true
  validates :name,      presence: true
  validates :phonetic,  presence: true

  validates :zip_code, format: {with: /\A[\d{7}]+\z/}, :if => Proc.new{|x| x.zip_code.present?}
  validates :phonetic, format: {with: /\A[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝﾞﾟ｢｣\-\(\)\\\.\s]+\z/}, :if => Proc.new{|x| x.phonetic.present?}
end
