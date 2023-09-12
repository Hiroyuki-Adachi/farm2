# == Schema Information
#
# Table name: desticide_purposes
#
#  id           :bigint           not null, primary key
#  name(名称)   :string(20)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class DesticidePurpose < ApplicationRecord
  def self.find_or_create(name)
    purpose = DesticidePurpose.find_by(name: name)
    purpose = DesticidePurpose.create(name: name) if purpose.nil?
    return purpose.id
  end
end
