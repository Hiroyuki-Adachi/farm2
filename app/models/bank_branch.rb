# == Schema Information
#
# Table name: bank_branches
#
#  bank_code  :string(4)        not null, primary key
#  code       :string(3)        not null, primary key
#  name       :string(40)       not null
#  phonetic   :string(40)       not null
#  zip_code   :string(7)
#  address1   :string(50)
#  address2   :string(50)
#  telephone  :string(15)
#  fax        :string(15)
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
