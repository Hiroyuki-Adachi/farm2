# == Schema Information
#
# Table name: land_homes
#
#  id                   :bigint           not null, primary key
#  area(耕作面積)       :decimal(5, 2)    not null
#  place(番地)          :string(15)       not null
#  reg_area(登記面積)   :decimal(5, 2)    not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  land_id(土地)        :integer          not null
#  manager_id(管理世帯) :integer
#  owner_id(所有世帯)   :integer
#
class LandHome < ApplicationRecord
  belongs_to :owner, -> {with_deleted}, class_name: :Home, foreign_key: :owner_id
  belongs_to :manager, -> {with_deleted}, class_name: :Home, foreign_key: :manager_id
  belongs_to :land
end
