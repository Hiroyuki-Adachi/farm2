# == Schema Information
#
# Table name: desticide_uses
#
#  id             :bigint           not null, primary key
#  name(使用方法) :string(50)       not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class DesticideUse < ApplicationRecord
  def self.find_or_create(name)
    use = DesticideUse.find_by(name: name)
    use = DesticideUse.create(name: name) if use.nil?
    return use.id
  end
end
