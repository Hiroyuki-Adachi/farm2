# == Schema Information
#
# Table name: desticide_crops
#
#  id           :bigint           not null, primary key
#  name(作物名) :string(50)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class DesticideCrop < ApplicationRecord
  def self.find_or_create(name)
    name = name[0, name.index('(') - 1] if name.index('(')
    crop = DesticideCrop.find_by(name: name)
    crop = DesticideCrop.create(name: name) if crop.nil?
    return crop.id
  end
end
