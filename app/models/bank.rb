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
  def to_param
    return self.code
  end
end
