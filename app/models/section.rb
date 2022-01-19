# == Schema Information
#
# Table name: sections
#
#  id            :integer          not null, primary key
#  name          :string(40)       not null
#  display_order :integer          default("1"), not null
#  work_flag     :boolean          default("true"), not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#
# Indexes
#
#  index_sections_on_deleted_at  (deleted_at)
#

class Section < ApplicationRecord
  acts_as_paranoid

  has_many :homes, -> {order("homes.display_order, homes.id")}

  scope :usual, ->{where(work_flag: true).order(display_order: :asc)}
end
