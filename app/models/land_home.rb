# == Schema Information
#
# Table name: land_homes
#
#  id                         :bigint           not null, primary key
#  area(面積)                 :decimal(5, 2)    not null
#  manager_flag(管理者フラグ) :boolean
#  owner_flag(所有者フラグ)   :boolean
#  place(番地)                :string(15)       not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  home_id(世帯)              :integer
#  land_id(土地)              :integer          not null
#

class LandHome < ApplicationRecord
  belongs_to :home, -> {with_deleted}
  belongs_to :land
end
