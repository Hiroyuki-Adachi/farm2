# == Schema Information
#
# Table name: systems
#
#  id          :integer          not null, primary key
#  target_from :date
#  target_to   :date
#  term        :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class System < ActiveRecord::Base
  validates :term,        presence: true
  validates :target_from, presence: true
  validates :target_to,   presence: true

  validates :term, numericality: {only_integer: true, greater_than: 2000, less_than: 2100}
end
