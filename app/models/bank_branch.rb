# == Schema Information
#
# Table name: bank_branches
#
#  bank_code  :string(4)        not null
#  code       :string(3)        not null
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
  belongs_to :bank, {foreign_key: :bank_code}

  def to_param
    return self.code
  end
end
