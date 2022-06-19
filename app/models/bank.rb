# == Schema Information
#
# Table name: banks
#
#  code(金融機関コード)               :string(4)        not null, primary key
#  name(金融機関名称)                 :string(40)       not null
#  phonetic(金融機関名称(ﾌﾘｶﾞﾅ)) :string(40)       not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#

class Bank < ApplicationRecord
  self.primary_key = :code

  validates :code,     presence: true
  validates :name,     presence: true
  validates :phonetic, presence: true

  validates :phonetic, format: {with: /\A[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝﾞﾟ｢｣\-\(\)\\\.\s]+\z/}, :if => Proc.new{|x| x.phonetic.present?}
end
