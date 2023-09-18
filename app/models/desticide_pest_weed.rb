# == Schema Information
#
# Table name: desticide_pest_weeds
#
#  id                     :bigint           not null, primary key
#  name(適用病害虫雑草名) :string(50)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class DesticidePestWeed < ApplicationRecord
  def self.find_or_create(name)
    name = name[0, name.index('(') - 1] if name.index('(')
    pest = DesticidePestWeed.find_by(name: name)
    pest = DesticidePestWeed.create(name: name) if pest.nil?
    return pest.id
  end
end
