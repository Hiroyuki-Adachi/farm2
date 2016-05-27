# == Schema Information
#
# Table name: work_lands
#
#  id            :integer          not null, primary key
#  work_id       :integer
#  land_id       :integer
#  display_order :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class WorkLand < ActiveRecord::Base
  belongs_to :work
  belongs_to :land
end
