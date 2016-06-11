# == Schema Information
#
# Table name: banks
#
#  code       :string(4)        not null, primary key
#  name       :string(40)       not null
#  phonetic   :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bank < ActiveRecord::Base
  validates :code,     presence: true
  validates :name,     presence: true
  validates :phonetic, presence: true
  
  validates :phonetic, format: {with: /\A[ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝﾞﾟ｢｣\-\(\)\\\.\s]+\z/}, :if => Proc.new{|x| x.phonetic.present?}

  def to_param
    return self.code
  end
end
