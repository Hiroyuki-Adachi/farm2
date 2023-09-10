# == Schema Information
#
# Table name: desticide_forms
#
#  id           :bigint           not null, primary key
#  name(名称)   :string(20)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class DesticideForm < ApplicationRecord
  def self.find_or_create(name)
    form = DesticideForm.find_by(name: name)
    form = DesticideForm.create(name: name) if form.nil?
    return form.id
  end
end
