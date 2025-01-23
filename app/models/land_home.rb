# == Schema Information
#
# Table name: land_homes
#
#  id           :integer          not null, primary key
#  land_id      :integer          not null
#  home_id      :integer
#  manager_flag :boolean
#  owner_flag   :boolean
#  area         :decimal(5, 2)    not null
#  place        :string(15)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LandHome < ApplicationRecord
  belongs_to :home, -> {with_deleted}
  belongs_to :land
end
