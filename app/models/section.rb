# == Schema Information
#
# Table name: sections
#
#  id            :integer          not null, primary key
#  name          :string(40)       not null
#  display_order :integer          default(1), not null
#  work_flag     :boolean          default(TRUE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#

class Section < ActiveRecord::Base
end
