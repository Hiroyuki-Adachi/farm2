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
end
