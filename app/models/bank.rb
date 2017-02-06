# == Schema Information
#
# Table name: banks # 金融機関マスタ
#
#  code       :string(4)        not null, primary key # 金融機関コード
#  name       :string(40)       not null              # 金融機関名称
#  phonetic   :string(40)       not null              # 金融機関名称(ﾌﾘｶﾞﾅ)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bank < ApplicationRecord
  self.primary_key = :code

  validates :code,     presence: true
  validates :name,     presence: true
  validates :phonetic, presence: true
  
  validates :phonetic, format: {with: /\A[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝﾞﾟ｢｣\-\(\)\\\.\s]+\z/}, :if => Proc.new{|x| x.phonetic.present?}
end
