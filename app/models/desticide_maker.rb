# == Schema Information
#
# Table name: desticide_makers
#
#  id           :bigint           not null, primary key
#  name(名称)   :string(50)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class DesticideMaker < ApplicationRecord

  def self.find_or_create(name)
    maker = DesticideMaker.find_by(name: name)
    maker = DesticideMaker.create(name: name) if maker.nil?
    return maker.id
  end
end
