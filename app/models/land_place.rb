# == Schema Information
#
# Table name: land_places # 場所マスタ
#
#  id            :integer          not null, primary key
#  name          :string(40)       not null              # 場所名称
#  remarks       :text                                   # 備考
#  display_order :integer                                # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#

class LandPlace < ApplicationRecord
  acts_as_paranoid

  scope :usual, -> {order("display_order")}

  has_many :lands
end
